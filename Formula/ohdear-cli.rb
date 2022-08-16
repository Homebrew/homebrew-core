class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v3.2.2/ohdear-cli.phar"
  sha256 "bc477d85a7213e9c023eb81c185db98dbfc3adf4e540d15e192cca18710cb9e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e10b8b559e7e371ded3575918b1679cb760bce8a4a6f1c4838dd6b321e0a4b63"
  end

  depends_on "php"

  def install
    bin.install "ohdear-cli.phar" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear-cli me", 1)
  end
end
