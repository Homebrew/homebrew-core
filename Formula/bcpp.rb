class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "ftp://ftp.invisible-island.net/bcpp/bcpp-20150811.tgz"
  sha256 "6a18d68a09c4a0e8bf62d23d13ed7c8a62c98664a655f9d648bc466240ce97c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d10a515f6173652ea39d12ff248fedc71bf6985d2d1121ce55d3c86d7e597ff" => :sierra
    sha256 "e9cbefdb72acc228f8e31afc7d6dabf3dcc1fac321aa88cd0834687afd15c9d1" => :el_capitan
    sha256 "55695704fc182a79be6761a720b18c0be3f416ef2602ea0048c8f2a00422bfa9" => :yosemite
    sha256 "5a8b1bf857e52ca6b30c4ef31547b23d807364075aec50a47c7ce16fdfc8b59d" => :mavericks
    sha256 "5cbc5e640e0c8ebcfeee4091364855bd0f67a54663a819a9f875f648e7cb48b9" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
              test
                 test
          test
                test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert File.exist?("test.txt.orig")
    assert File.exist?("test.txt")
  end
end
