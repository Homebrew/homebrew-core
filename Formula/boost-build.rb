class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/2016.03.tar.gz"
  sha256 "1e79253a6ce4cadb08ac1c05feaef241cbf789b65362ba8973e37c1d25a2fbe9"

  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d67cd7c3f2986f1e9def0583b8b5c13e3dce1eb8434acb873ea416973a99fbb4" => :sierra
    sha256 "54e173a7e91aef66bfdb5c497156915518d69dd9a062552ab48e62d443adaa04" => :el_capitan
    sha256 "a61eaa58a94a1f236d1dc6e652f7cb57e241e0dd5664bb5cadc258b73ce34887" => :yosemite
    sha256 "dd11acd551a6c26f216743eeb938d704f92bc5349c79b5f8e853176e311b7990" => :mavericks
    sha256 "03d989cecd3251825466d725f6a00212979b2d41fce344380606b482eaab9b80" => :mountain_lion
  end

  conflicts_with "b2-tools", :because => "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end
end
