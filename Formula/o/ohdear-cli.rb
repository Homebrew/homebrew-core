class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://ohdear.app"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v5.3.0/ohdear.phar"
  sha256 "54c78e7c272a6e38e85add9cfb37621985c82ed63c57627b432fa4e09d7e7443"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36d5fa990d9532cae0e3750a2510d5e323f5f7157897913c21b51b372b6d8016"
  end

  depends_on "php"

  def install
    bin.install "ohdear.phar" => "ohdear"
    # The cli tool was renamed (3.x -> 4.0.0)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"ohdear" => "ohdear-cli"
  end

  test do
    assert_match "Your API token is invalid or expired.", shell_output("#{bin}/ohdear get-me", 1)
  end
end
