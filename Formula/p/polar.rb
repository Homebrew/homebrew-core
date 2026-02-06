class Polar < Formula
  desc "CLI for the Polar developer monetization platform"
  homepage "https://github.com/polarsource/cli"
  url "https://github.com/polarsource/cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c4075f87f22f83b4b33cb999c13ddab0a57f9484bd8e580106c2b601da5edc71"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "oven-sh/bun/bun" => :build

  def install
    system "bun", "install"
    system "bun", "build", "./src/cli.ts", "--compile", "--outfile", "polar"
    bin.install "polar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polar --version")
  end
end
