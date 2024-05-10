class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "653e1190a82a39dae733487a11aa641ba62a36ae1e221c21844f822575961919"
  license "Apache-2.0"
  revision 1
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16329c5d23a092be27d3474caa53bf33ce5296b507934c8caf748545a5a96aad"
    sha256 cellar: :any,                 arm64_ventura:  "b3f7ee611537e7eb2b0deb125d8c987e5c4279bc1d180fb7579754914a228206"
    sha256 cellar: :any,                 arm64_monterey: "b12036b9c17a4e91dcef83a7ab59322260fe0345de7b7168dd211727b951e469"
    sha256 cellar: :any,                 sonoma:         "6c1f28f16da5b536348d990705b7414b1077e5f0647fae1ba5e3cfc5d0187933"
    sha256 cellar: :any,                 ventura:        "d7b6b29e30c2c0437133e2e912115fe92dc0c72f6f6cc62e8df6c47a9232879e"
    sha256 cellar: :any,                 monterey:       "084bcdbe290f0c7d241e74dc0c01c3c2d5d10d879d28b41942be5ecabe3c0b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "179c23906a88e097a9b8365d642e9cc5ade157d18263630577671d1f668335c3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "watchman"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", "util", "completion", shell_parameter_format: :flag)
    (man1/"jj.1").write Utils.safe_popen_read(bin/"jj", "util", "mangen")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
