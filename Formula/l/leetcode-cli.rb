class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "073b4725ee6ff92e51cd25093e1c30fd51c82b2076e1a1e32d60fef3a9a176f1"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1344c75b2a3f07c843a8c91ef51ecbcf75f99af9cc4ac47021f7b38a8cb95f7"
    sha256 cellar: :any,                 arm64_sonoma:  "e1087c05f54a3c5632365451648cd7cc20c169a1719d0eb8ef5f19f5ee36540c"
    sha256 cellar: :any,                 arm64_ventura: "82a5a6b5c2078241b06f529b2a3361e15c798c66b961b8106b57065bb1a7ee41"
    sha256 cellar: :any,                 sonoma:        "9f350b776b649f22bf8028d4abc4b90024ae46d8b72a4ac7f1a03aaac19bdf81"
    sha256 cellar: :any,                 ventura:       "34e5536419363a2c3224228ffb43e00fef01fbdfbe20075e0917e434a75dcfd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81db49df8f9fc26dab488cfce816d8512d381cdb89cbb901e93b95dd49c26d8c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1", 101)
  end
end
