class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "3a99528539e414a3373f24eb46a0f153d4e52f7035bb06df47bd317a19912ea3"
  license "Apache-2.0"
  revision 2
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "72bf45459f768db11ec4d2f116f1d46b2f63b1197e4d64ef4b3eeaf412b594f8"
    sha256 cellar: :any,                 arm64_sonoma:  "36e62f131229425ca98a8b6a8705d4e333879913fd94932bf95fe35dc9ac07a5"
    sha256 cellar: :any,                 arm64_ventura: "705b5e8e49fd8ddb634c21a31e08f924638a8f20ca50e310fec155c1d45fc051"
    sha256 cellar: :any,                 sonoma:        "a5c8cebe71747c47222f8a443fe7cef1eaab0b39310a13088a3424f56f1eabf8"
    sha256 cellar: :any,                 ventura:       "42c15f2188ac4a023652985cf78d03b7153cb14a826f17ba108889b570efc7c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b45531574b6d4bc11e553c9c4c9350f4b66167bed7379c0776ed6f9b5798c495"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # patch to use libgit2 1.9, upstream pr ref, https://github.com/jj-vcs/jj/pull/5315
  patch do
    url "https://github.com/jj-vcs/jj/commit/b4f936ac302ee835aa274e4dd186b436781d5d2f.patch?full_index=1"
    sha256 "7b2f84de2c6bbdce9934384af2f7f2d0b7f7116c4726aeef87581010cdf1564e"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)

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
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
