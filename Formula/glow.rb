class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.3.0.tar.gz"
  sha256 "828d8453f026a24cd7a6dcf8d97213fe713cadcfab7ca969d5f4c8338d88bb86"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5b7608d88429fd32f4905bb3506d00835d03a314083024815ce43581c30e2756" => :big_sur
    sha256 "56362f0bc55784e418d45eb431b57153fed78e7da7ddd2c47373038735ca71fe" => :arm64_big_sur
    sha256 "74925c63282ec0f602131805f9733850d4b27f70fca23efd81d5451316b45606" => :catalina
    sha256 "c98f41246b644d11f0562b5a79129fa6d4d673094bf8d9b9a4f92282751ebdba" => :mojave
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
