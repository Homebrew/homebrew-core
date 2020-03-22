class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.24.3.tar.gz"
  sha256 "e31d5afb9028fb5047b5a2cc5f96c844f6480d600643a12075550f497e65f5cb"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d322960e087822f7d7713d4f4443c7f17b4bf0c0447217df8f57c17c80e6211" => :catalina
    sha256 "c0bd10c385ee390792fdc49b1cb6a57afbfe7ceac142a096cf44050dacf713c3" => :mojave
    sha256 "f476743082dea51f61f169fcbc34d11f886054f90a479602d85b641e784433ea" => :high_sierra
    sha256 "d9f076f1c3010e57e77bb583ba63855f1db92e8fb0cd432cfefe79ce0d26d9b5" => :sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
    system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
    system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
    man8.install Dir["man/*.8"]
    prefix.install_metafiles
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
