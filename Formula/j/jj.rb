class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "e39f80edaa01da29e86782424d031c38324eabff10c44704781c80fd60c9fb0e"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "549b74afbd6a3d90a5db8b2c603bbf4a2f970349edbe179556a577a6c266f181"
    sha256 cellar: :any,                 arm64_ventura:  "e3ede281d14c2d947abca361ead9b9dc55cc86087474154c73c4f53c65fc9bf7"
    sha256 cellar: :any,                 arm64_monterey: "b287fa57a5815e430a77251b4deca881d0bb5d8cb0630ffe93ede49f91ec6027"
    sha256 cellar: :any,                 sonoma:         "7e94a1a1b2187c0bb7142b69c5aa72265b2790f8d2de692e6d838aa95627772e"
    sha256 cellar: :any,                 ventura:        "0668de106b9d7fcc48685b6c36f343a3d23e22f589642c4dc0e649c82832b214"
    sha256 cellar: :any,                 monterey:       "05a24c34475d54362a16c0748dfffebbd9ac54ee1aa6d484e33bf9e8d8961bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39af6104574cdedcb611ce684895eaedd3dc2548bad9cbc97c291dc74a6a8c3a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args(path: "cli")

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
