class Mp3cat < Formula
  desc "Reads and writes mp3 files"
  homepage "https://tomclegg.ca/mp3cat"
  url "https://github.com/tomclegg/mp3cat/archive/0.5.tar.gz"
  sha256 "b1ec915c09c7e1c0ff48f54844db273505bc0157163bed7b2940792dca8ff951"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cb3c8420e4858acf5edd529ce7d68c79d03f3d463c45460d9209308daa292db" => :big_sur
    sha256 "d5b602f2c0aafa37b863446069097523612ae44f2a14c4e49f179445a4b0edd5" => :arm64_big_sur
    sha256 "07766f0495aa6c8566d8594a64f5004d1ad56f7e522f90cc1dcaf58001e7d2ab" => :catalina
    sha256 "e075f29990e6b5222d3e82ed27de698bed42257097e9bd59f0d60f64ea7ae46b" => :mojave
    sha256 "91152cced755097c42117c72e71f3db9023716e2e9befd1e8a6630fd225e3cea" => :high_sierra
    sha256 "3954ad75806e1948a4e69efb74fb2e86a4920c7e6b61537ca48f696289ca998a" => :sierra
  end

  def install
    system "make"
    bin.install %w[mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf]
  end

  test do
    pipe_output("#{bin}/mp3cat -v --noclean - -", test_fixtures("test.mp3"))
  end
end
