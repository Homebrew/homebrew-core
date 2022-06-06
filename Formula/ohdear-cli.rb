class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v3.2.0/ohdear-cli.phar"
  sha256 "9bc29673e7bdb6749cbe798d01386351d7f8f93cf33b5721d6be6179817a3980"
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
