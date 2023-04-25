class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v3.5.1/ohdear-cli.phar"
  sha256 "d981492cc12eb3aa185c937223632da4390f35738eb1ad0cf432895ed08c1a71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd62cefeb49e45b6654d6057fbe7780cc9e5d74e4d6211b1862bbb03709e4fa3"
  end

  depends_on "php"

  def install
    bin.install "ohdear-cli.phar" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear-cli me", 1)
  end
end
