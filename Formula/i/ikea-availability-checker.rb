class IkeaAvailabilityChecker < Formula
  desc "Check availability of IKEA products in stores and countries"
  homepage "https://github.com/Ephigenia/ikea-availability-checker"
  url "https://registry.npmjs.org/ikea-availability-checker/-/ikea-availability-checker-2.2.1.tgz"
  sha256 "ad004f30005f378e712d1151c7823b0419eed92f3fc7535a5ccf3a6ef4783df3"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Wien", shell_output("#{bin}/ikea-availability stores at")
  end
end
