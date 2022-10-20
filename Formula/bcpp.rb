class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20221002.tgz"
  sha256 "ad87caf9f1df0212994ca6eff1c4e0e7b63559aaef0a4ba54555092ebc438437"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da20cc17b58e3c8e50e625466fafcfeb982a29c6112788e8d3d725a8a301c75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f47f8f238b0196c31f31bf94c3a2f10743f21656da26e8e5049a3c964493b528"
    sha256 cellar: :any_skip_relocation, monterey:       "07c75d2ddb2e040d14c4dd35112579ebc815d8ad623a093ba34785d110e9e9c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf240394669e9cf1729060888eaa8076fbc39093788ff5c395db996718941a3"
    sha256 cellar: :any_skip_relocation, catalina:       "8527335dbcc1422c229a02962c692e22636c3cdf14de756460d2daf87de4e7b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed43f0ca103d4eae3359136737fa5dd376b274e234c2ee7a683e20b1f8b208f"
  end

  fails_with gcc: "5"

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
