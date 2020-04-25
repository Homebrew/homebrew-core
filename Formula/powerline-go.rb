class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.17.0.tar.gz"
  sha256 "d7825168044159dfdd3983519ea26cf8753f24c3d8c0600ce494c4a6db7a015f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3904584cc8da7767d1edd7c97abde35b4368e47f187e78d36fc208cbfcc7a11" => :catalina
    sha256 "81a045e185ed9654ae30a8d025e7259f68d56e9741f81fdee5b61a5708e8ba0f" => :mojave
    sha256 "89111b7e2c874ad417a19891fd1e101c7254bb0913c8a0c5bf2e03277fbbbfb8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  test do
    system "#{bin}/#{name}"
  end
end
