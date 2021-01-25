class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20210108.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/bcpp-20210108.tgz"
  sha256 "567ca0e803bfd57c41686f3b1a7df4ee4cec3c2d57ad4f8e5cda247fc5735269"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "447070d7c227cdb2e5c8df360c8ea31c8f9fa89b39e2092a3a888a40caedb523" => :big_sur
    sha256 "1c7332e45d68c7c34e04b36935495e8e189944442650379f2c920757f2b210b7" => :arm64_big_sur
    sha256 "1f2a9da46190bde2855e3bdc5d430302c831e3ff0eb3e3c34f8754bbe73744da" => :catalina
    sha256 "1872e08cd8d7addb8459865d451622d05ed4f4fc2f91e3a6f144ba1fe483b27a" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
