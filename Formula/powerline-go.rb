class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.15.0.tar.gz"
  sha256 "25d54855473c13348423d56406ebd0edc9318b3d4518d151994d90e49f496cb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "765011e80c868376faeba4cbba86085a66e2165cac4931013acd4c0ba63c46d5" => :catalina
    sha256 "3360d1be2880b36dccac481f62f4bb9034d30f0ca2c77d9d75dcdb4f9ce9f1c2" => :mojave
    sha256 "f14489bb9af622dbe2cbd3c05fa4f5523dba74a619ea8875a455dd4c5ced07d0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    system "#{bin}/#{name}"
  end
end
