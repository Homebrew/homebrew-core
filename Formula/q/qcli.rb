class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools.git",
      tag:      "v1.3.1",
      revision: "0573c33953d02db53812a2420f174d6b1233751e"
  license "GPL-3.0-or-later"
  head "https://github.com/bavc/qctools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ebfb848efd1dcab735f34f617a6c727a118b9c387bb9b0812218b01161071bb7"
    sha256 cellar: :any,                 arm64_ventura:  "b1aa05f59c9042ee113e44e57007b16525aa481481fa2658722ed6e7f0870529"
    sha256 cellar: :any,                 arm64_monterey: "451ada5474320cbdc9980968b528926ce6735d620dfb07eb59bfbd93a54246cf"
    sha256 cellar: :any,                 sonoma:         "33b338d2168fe8993af2724f5c2716dd27f6933d6bed6d904de12ac8a0d53267"
    sha256 cellar: :any,                 ventura:        "b12ad220348a6f4fc09d929cd81ad82a9c82bfe247134041774a918dafb699df"
    sha256 cellar: :any,                 monterey:       "62d8e6488cbfb30cf8817dd2d39874b51f323a90540c24dcbbead43103996a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bcebd3547d51d320dbb52094543b170070fddb0404f6897c34dcbf44069d8c"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "qwt"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["USE_BREW"]="true"

    cd "Project/QtCreator/qctools-lib" do
      system "qmake", "qctools-lib.pro"
      system "make"
    end
    cd "Project/QtCreator/qctools-cli" do
      system "qmake", "qctools-cli.pro"
      system "make"
      bin.install "qcli"
    end
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system "#{Formula["ffmpeg"].bin}/ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath/"video.mp4.qctools.xml.gz"
    system bin/"qcli", "-i", mp4out, "-o", qcliout
    assert_predicate qcliout, :exist?
  end
end
