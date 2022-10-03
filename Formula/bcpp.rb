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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8883d3bd16c07533655b35ee6e12fbcee46b59a65a623125c211bce60e088a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a700a9f6f80235507a7547989a0d16129821326d53d66a3850c750559e08ed74"
    sha256 cellar: :any_skip_relocation, monterey:       "dae15a3a40dd6e8d6dacca8df007f28a98e03237d1d9e2232811827e0c158284"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cadc19aa73c9615978e1fe09e3f367a23e97f43fd40119cde2a018b704f8932"
    sha256 cellar: :any_skip_relocation, catalina:       "06ee7591092542529d070ae475ae7cbae2f12bae5690f7fe2dce7b056024880d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d63146f07c0c1186901b0df0954734d6942f7ae1cb9a0912c6e90f87867532"
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
