class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v4.3.1.tar.gz"
  sha256 "b69b2b90914e03f4a54453d740345cad222b379c366ec3788f4fdf4b1f01ac64"

  bottle do
    cellar :any_skip_relocation
    sha256 "08ec6c718e6272123dfcc07a0432a7199ed554626127a84eda62dbf3fcc7ccba" => :catalina
    sha256 "f1f71667f54ace6451e02b2e9a8daebe74d1e4fb05c7ad638cf5a25796bffa3b" => :mojave
    sha256 "04328f8b88f378dce0468639471ebb11b42ffaa1ec5bf4ca511737d5940e1bd0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
