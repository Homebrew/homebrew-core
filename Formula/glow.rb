class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.3.0.tar.gz"
  sha256 "828d8453f026a24cd7a6dcf8d97213fe713cadcfab7ca969d5f4c8338d88bb86"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bec804d3c8ff8ff3dbd7d265ad39a213cb90173dead7d81d15f8f606ed03e15d" => :big_sur
    sha256 "f55176ddc5b1f40503ad9b2599c5474e58a8e806dc2a33c7bd54375f110ad865" => :catalina
    sha256 "bec57a12c75182f65427aceabed7be270be7890e37794429780791f80ac7fd85" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}", "-trimpath", "-o", bin/name
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
