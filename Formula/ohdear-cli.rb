class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v3.3.0/ohdear-cli.phar"
  sha256 "54e1b773aaf0278a1df9ae9f88aa5c9a6c3b411fea5434177cec12fab8843b9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d25b01d5f723612a16d5e7dde40a54507af4457d27b6dbb534c798fb064b605c"
  end

  depends_on "php"

  def install
    bin.install "ohdear-cli.phar" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear-cli me", 1)
  end
end
