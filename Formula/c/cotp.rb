class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "649119c3d49a16a1fd439949485763f242614ec05dc6d9f84df0d22120988d2e"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b235fa29dc499605456c62985db76f3ec093298374fcffa4462552552d16ede7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "323ba01cd4f7a723bb17c22e58a28e724bda23b89630583a8cd72cc8c291a315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b1e7e2a4076c12ec69c76cb6b8c3a46c18ba9d5fcba951273b0dd44118cd881"
    sha256 cellar: :any,                 arm64_linux:       "95534c092fc5a947995ba57180f00891b4601e3a762ac8dd148530390c2e4d39"
    sha256 cellar: :any,                 x86_64_linux:      "82eb9fe23641497563ed85f99a0495d79a7ed181e03739512d0da153d8f0e912"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
