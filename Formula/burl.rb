class Burl < Formula
  desc "Shell script wrapper that offers helpful shortcuts for curl(1)"
  homepage "https://github.com/tj/burl"
  url "https://github.com/tj/burl/archive/1.0.1.tar.gz"
  sha256 "634949b7859ddf7c75a89123608998f8dac8ced8c601fa2c2717569caeaa54e5"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb8a86db7325cafed76e441f755837b1771117724edf90ab523cbce98656cf85"
  end

  def install
    bin.install "bin/burl"
  end

  test do
    system "#{bin}/burl", "-I", "github.com"
  end
end
