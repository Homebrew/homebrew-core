class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.18.0.tar.gz"
  sha256 "f7418109e89a8280f2181c675a7790669ba0b0ba5c0eae2bca13879257f96d57"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b0d6f9c5324165ee50404989724a0fac3413ac74ee9be71fffc0823d0bae6af" => :catalina
    sha256 "07e4b014438c4de846d49c8ccd7d0f2a362b1271f50386916218c4a1c9edb5ce" => :mojave
    sha256 "1a872e444bba7d8ae32c266817b4b8c1985477b52340310e92f502f20c9b161d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  test do
    system "#{bin}/#{name}"
  end
end
