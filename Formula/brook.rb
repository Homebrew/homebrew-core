class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20210401.tar.gz"
  sha256 "6229b2f0b53d94acb873e246d10f2a4662af2a031a03e7fb5c3befffcd998731"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    cd "cli/brook" do
      system "go", "build", *std_go_args, "-ldflags", ldflags
    end
  end

  test do
    output = shell_output "#{bin}/brook link -s 1.2.3.4:56789"
    assert_match "brook://1.2.3.4%3A56789", output
  end
end
