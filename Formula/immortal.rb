class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.24.3.tar.gz"
  sha256 "e31d5afb9028fb5047b5a2cc5f96c844f6480d600643a12075550f497e65f5cb"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b1f289dbe2b0998f091ebf9fbf6df2894f0eb3d447df2b5840915a53cdb3c09" => :catalina
    sha256 "c35c0718289bac0d3557ac5d17af6895765557d2c5a7124f389653163b40bb36" => :mojave
    sha256 "702cb544d23450cf258ef7b9287e99925e8cf715e1708513694f9068233a5cba" => :high_sierra
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
