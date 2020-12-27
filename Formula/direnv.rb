class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.26.0.tar.gz"
  sha256 "b3dbb97f4d2627ec588894f084bfdc76db47ff5e3bec21050bb818608c7835b9"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c79af7963300877b62c3debbe068b9323579586f7a1b934a4e86f91cdaa65b30" => :big_sur
    sha256 "1edcd76a37ebd6ef791134ce3c2538bff163c38be5397833ac512c234bbc2698" => :arm64_big_sur
    sha256 "cc182495b66533285fc592dae75c76bcb034ae214b2eed34220ecbd60bbfe8a8" => :catalina
    sha256 "b9b3f2b300c8928de283e76cf3685c6efddf4435032c86e374827567cbffda95" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
