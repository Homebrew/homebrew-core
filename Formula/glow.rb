class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.4.0.tar.gz"
  sha256 "97d373e002332e54e2fb808ea38f098ca49e2b88038c115bd6d33d0b3b921495"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56362f0bc55784e418d45eb431b57153fed78e7da7ddd2c47373038735ca71fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b7608d88429fd32f4905bb3506d00835d03a314083024815ce43581c30e2756"
    sha256 cellar: :any_skip_relocation, catalina:      "74925c63282ec0f602131805f9733850d4b27f70fca23efd81d5451316b45606"
    sha256 cellar: :any_skip_relocation, mojave:        "c98f41246b644d11f0562b5a79129fa6d4d673094bf8d9b9a4f92282751ebdba"
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
