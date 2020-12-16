class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.25.2.tar.gz"
  sha256 "c42624086c9fb5dd66e4d49e2a30907dd3038126a5dad3369c5a1c6f15d7b9ec"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c79af7963300877b62c3debbe068b9323579586f7a1b934a4e86f91cdaa65b30" => :big_sur
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
