class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v3.4.0/ohdear-cli.phar"
  sha256 "54e1b773aaf0278a1df9ae9f88aa5c9a6c3b411fea5434177cec12fab8843b9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2bd809e756e658453caa7c5ac7e8e11011ae807538b7df05726fe68c824f165"
  end

  depends_on "php"

  def install
    bin.install "ohdear-cli.phar" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear-cli me", 1)
  end
end
