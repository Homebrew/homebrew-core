class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "ab74189d84dd4765b8ddd5cec6e308b180ddda2069f7b357efcfa41db408df74"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2273486dcc93637a2cc932d945ab4857f214d8ae6075f94258c9684295b1c33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dda6f5da994d414c1c2a411664b2c3f36a55bbcd7a753272a14267448b07c2fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f0a46e9c44b08e7cab333c5c460391e25919f03103527cf51de68dc3388fcc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b93d705824318596c78c46a01d992ee2f2c6e4647f90411751396df1eb808510"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e621483bd51ab94c2e173c8a50c194982d405607055c75c516012988addfc8f"
    sha256 cellar: :any_skip_relocation, ventura:        "f21fc5a2d2d7b3b0b18172597ce3e7b6fb9a07454fab260bc48c5c17297dd00f"
    sha256 cellar: :any_skip_relocation, monterey:       "1c08d740c840316b4459259f4eafa6becd90c19d81e4628d606794c81e169b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d2b82f2da826e4c5b0eadd3503de56fdf999d21c13ea8eecee1f9e144708ba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}/cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}/cotp --version")
  end
end
