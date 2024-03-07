class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "2dcb890b64c3d576159d2a0c19177f9e622d444506f74a97e92806613b610ba6"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "209536d5e2d4caf8b1856358a2c1974cf2c1e8fde3c7edd4adf74b6c9edee0fc"
    sha256 cellar: :any,                 arm64_ventura:  "ca887ca640c7ce42e70e0eb5148f18b19cfe82b8f15d43b191ef30e3541f553a"
    sha256 cellar: :any,                 arm64_monterey: "0e8f585dd7d92e7b30db3f06bc774c5914acb1763b1c48bd8e21bef081e75136"
    sha256 cellar: :any,                 sonoma:         "3d8503aef92e5a4ca8f07ebfe39e8a5757713c75c0f115118a2418f38c8e5ecf"
    sha256 cellar: :any,                 ventura:        "01d88f7b0f8c0ae7a545f957d1052a969e242118a8bb1ee4a2f655ac7997235e"
    sha256 cellar: :any,                 monterey:       "bf7e2b1c6c09328f351690d5da37d8ef97115a7ee796961b827b747cac2cc41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3787f960a8d5883a188e97a433aa392a770af3934776a8e6393d7988af6a2d9"
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
