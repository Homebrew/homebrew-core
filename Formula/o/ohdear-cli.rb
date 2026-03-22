class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v5.1.8/ohdear.phar"
  sha256 "ab399d4301a23ebfbfb49a430f0c3caf558919c4549f36c027cf8c89095f2f87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12f2277ff9e5b416aeae46d552d945bdffe86af9096d0df832adca76a7748e79"
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
