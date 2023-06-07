class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v4.1.1/ohdear.phar"
  sha256 "f7a7c2045f4305c0e2584b89621788ec271f016fd470a4b05cfdc8265545a4b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1fe3706776c3d91d2f66074ef8e9325303a5cf18b36dcc28859d551bf8648515"
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
