class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-2.0.2.tgz"
  sha256 "26810b12aaa3b1794f7dc384db4dcc8e6be721ff14d6d97d414f7499b6a11aa0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "12354f7a09c443078fbb589b9a5d18082bb65ce9d8c5fc91f333597dddddd32e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b65e24ac1b5a2dbaa84bb7e322769a5998a51057bdfa1d47848c3e46787d5a7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b65e24ac1b5a2dbaa84bb7e322769a5998a51057bdfa1d47848c3e46787d5a7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b65e24ac1b5a2dbaa84bb7e322769a5998a51057bdfa1d47848c3e46787d5a7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "184b4a9e54bae80675c164bac45864224e4e3cf4ff42a624303d53daa24ab078"
    sha256 cellar: :any_skip_relocation, ventura:        "184b4a9e54bae80675c164bac45864224e4e3cf4ff42a624303d53daa24ab078"
    sha256 cellar: :any_skip_relocation, monterey:       "184b4a9e54bae80675c164bac45864224e4e3cf4ff42a624303d53daa24ab078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b65e24ac1b5a2dbaa84bb7e322769a5998a51057bdfa1d47848c3e46787d5a7b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna endpoint list 2>&1")
    assert_match "Available endpoints:\n", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = shell_output("#{bin}/fauna endpoint add https://db.fauna.com:443 " \
                          "--non-interactive --url http://localhost:8443 " \
                          "--secret your_fauna_secret --set-default")
    assert_match "Saved endpoint https://db.fauna.com:443", output

    expected = <<~EOS
      Available endpoints:
      * https://db.fauna.com:443
    EOS
    assert_equal expected, shell_output("#{bin}/fauna endpoint list")
  end
end
