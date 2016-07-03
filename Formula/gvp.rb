class Gvp < Formula
  desc "Go versioning packager"
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.3.0.tar.gz"
  sha256 "e1fccefa76495293350d47d197352a63cae6a014d8d28ebdedb785d4304ee338"

  bottle do
    cellar :any_skip_relocation
    sha256 "40e7e581961e3e16ba97125accab5eae8d2eb24d0e06b1ef80feb88a35ed6727" => :el_capitan
    sha256 "739213d2dc13b931215f65f95569d3078b3a5927b9e44c6a3728d5eae3f2ff4c" => :yosemite
    sha256 "5bb08f53cdb878f398a57560aca0a4cb8908fbb9cd5ca1cfecf5b627c6e37014" => :mavericks
    sha256 "d940a179bae92e734b725f27e766abe525cd82c98599e52ae201f4be2bd1787f" => :mountain_lion
  end

  # Upstream fix for "syntax error near unexpected token `;'"
  patch do
    url "https://github.com/pote/gvp/commit/11c4cefd.patch"
    sha256 "59379b52fc13d79ea03de453cd58df98ad5ddd49ba3ba5d784b8bee7649e9cd7"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gvp", "in"
    assert File.directory? ".godeps/src"
  end
end
