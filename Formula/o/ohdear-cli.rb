class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v4.5.2/ohdear.phar"
  sha256 "fa2e0e84d47adefea1a3f5e23274c245285957208e33d2e143f0ddb617b60112"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f610a110de9f9bf223b8107dd9bd718c53d20d97fcf1962ccd6cea4a972c1327"
  end

  depends_on "php"

  def install
    bin.install "ohdear.phar" => "ohdear"
    # The cli tool was renamed (3.x -> 4.0.0)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"ohdear" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear me", 1)
  end
end
