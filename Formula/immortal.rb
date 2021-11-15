class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.24.3.tar.gz"
  sha256 "e31d5afb9028fb5047b5a2cc5f96c844f6480d600643a12075550f497e65f5cb"
  license "BSD-3-Clause"
  head "https://github.com/immortal/immortal.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01fb4ace3e58bd7f6a1b2c16816286b06862b73e4aeb9b52e17b2d1372451c5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38ec22b15e305094470a996cd4a9b4362f225da6d573618403c58bb949c39ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "f0eded6c51aa4e01ba1aea618c56bac6450db7ce06c4234d890160d615d1ed1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "96761cea1b43a1550e499f854dd6969f886a18345dddc24615ca75e10a4bf1e2"
    sha256 cellar: :any_skip_relocation, catalina:       "4b1f289dbe2b0998f091ebf9fbf6df2894f0eb3d447df2b5840915a53cdb3c09"
    sha256 cellar: :any_skip_relocation, mojave:         "c35c0718289bac0d3557ac5d17af6895765557d2c5a7124f389653163b40bb36"
    sha256 cellar: :any_skip_relocation, high_sierra:    "702cb544d23450cf258ef7b9287e99925e8cf715e1708513694f9068233a5cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44afbe226bc53ce9abec4435e8057dc307d0f73bce4ffa804460801f66978917"
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
