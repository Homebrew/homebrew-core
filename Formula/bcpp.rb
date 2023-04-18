class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20230130.tgz"
  sha256 "ebc9935b1e0eb72d8aaf9379f2def66af839af3c06e4147aae4b1347eb272519"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "225a1ab659784c0dce94579e1e7c1b20b7180e5bc2e836e96d6f5b400a9b18bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a0b96f9971ccd11b8fef6e938e3a177851501f910dc0da45619d319372832a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "602eae881b1448b893cbc3f748cd7e0716908b0e50369b7b47d8d633a3fa4769"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e9caea33a17f03930130cd40e31ebe8b5186fe545698f3035828817a459c4c"
    sha256 cellar: :any_skip_relocation, monterey:       "9144ea39e29b465caba77b7583a109c8c95ee2a45d9b689fca98dd2284c262eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b5a21d558ca2b49c55a505494d83a314afe3781ca96fbe3e3c1d811c0adf8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da477c21a11d38be1394447dc58246b746e09b3c213aed89ad13369c29be9c7"
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
