class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v4.2.0/ohdear.phar"
  sha256 "99623517ff43332a00e61d83899dea56c7df382d51b54b179f7ebef763936474"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04877da36bbd2a415fc95431af89235477da73ba81ece0bea283f62285ed4308"
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
