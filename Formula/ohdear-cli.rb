class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v3.2.1/ohdear-cli.phar"
  sha256 "5caf03357e600304e331d003e684c5afd93d317da10b689f9389c8d94d7f2fee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfeb6971f0a46393da6698a6e74482066dd3b1762bf28ff26897e5d39303c54a"
  end

  depends_on "php"

  def install
    bin.install "ohdear-cli.phar" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear-cli me", 1)
  end
end
