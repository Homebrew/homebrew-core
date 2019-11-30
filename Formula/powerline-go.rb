class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.13.0.tar.gz"
  sha256 "0c0d8a2aca578391edc0120f6cbb61f9ef5571190c07a978932348b0489d00ea"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    system "#{bin}/#{name}"
  end
end
