class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.82.2.tar.gz"
  sha256 "726fd5dc8b1782c168cb3977cffbde591a6769296c87d8fc4a68defc2680822e"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "381d4faebdafc899f6cd0287bfed044a65742e3d752a6e50099109936e595d09"
    sha256 cellar: :any,                 arm64_ventura:  "584762d37a0afda23fccc078db3c24fa529d4988b79d971ed28bcb2032c76e8b"
    sha256 cellar: :any,                 arm64_monterey: "1348cac79ea591c73225aaed996a3b98ddd622ae0af07041a098384d30ecac7c"
    sha256 cellar: :any,                 arm64_big_sur:  "c90349bdb485d1c6ea8225becb3fc4f853d7e6ba1031af424e4773c15063b3cc"
    sha256 cellar: :any,                 sonoma:         "fd7f7983c5fa4989bbedd6dcff12407b6c95a2c4c1410fbc7f4524a791e4c635"
    sha256 cellar: :any,                 ventura:        "8642e9d53a80c77771e233c0ef61cf0a053d5550f1bdaeef047b7a69a3ba2325"
    sha256 cellar: :any,                 monterey:       "fde8c80968b130fba84ae870c7311b397640406c62121f7543d464b425e8bda8"
    sha256 cellar: :any,                 big_sur:        "70f1e173ac67b0b23a89362c8fe5c4ebbc78eba232c8c147d6a96d800ea3b476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7da3e4c60a27e659f7964a703d8932c39e45d48dc06366b6f4c104f378dc387"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
