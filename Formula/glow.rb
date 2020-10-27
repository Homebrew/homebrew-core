class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.1.0.tar.gz"
  sha256 "c9a72e2267b95e39033e845961ad45675c9f0d86080b138c6a2fbf2a5d3428d1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "74b952b5b86be093d4219da3c397cd9cd5d8f70f020dc678f03a1307e4ddf388" => :catalina
    sha256 "0c8e878a2c2bbcd38fe14c20df66c9707117e35086cc83f0827ce2b1d79f0f15" => :mojave
    sha256 "ec087264a796471735d889b74174e02d60f5af626fcdd6dfaffc7fdd0bbfb5b1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
  end

  test do
    (testpath/"test.md").write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS
    assert_match "# header", shell_output("#{bin}/glow test.md")
  end
end
