class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.5.tar.gz"
  sha256 "03d70ff4e16f337dc2c0299fc69f3cf3d2c44a747b912f28e6b2c34d0cb27e21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7f504485f5c8190ffb209951b4560f3ed47be6073f3044eec0fbd83183600a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "201836392f27810d029409c5e24ffd3dd147d7f58e675ba234f016ca794509a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f35416f0d0d12e657653ce06cc92a2e7bf39cb64c7916db6f701067f07ede3d5"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a1ea4fbf9b60987ab2756f2c4fab299daf7b79b0fb98c7ff4191a2c55d7119"
    sha256 cellar: :any_skip_relocation, monterey:       "0b82d5db56d064f3bbd2380589b08c70476d9fac87ee39f20646e646bc13bd1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca5b06ae0dbed7f78fc7215fee98b5da16334a1a72eeacad718377971f9bac0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "429e80d70b064667ca0a643ab6bd7723adc5f5528fcada7bd0d7289c4629d1ba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
