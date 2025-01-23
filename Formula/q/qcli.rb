class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools.git",
      tag:      "v1.4",
      revision: "982619270ff49987328343909ea2179d1af52004"
  license "GPL-3.0-or-later"
  head "https://github.com/bavc/qctools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "01381abc80e93b31c44d6f50a65f6e4feebb5d82380b4331b9b1fe58f37b9aaa"
    sha256 cellar: :any,                 arm64_ventura: "5f7e15ca1e3057ef5d2d2c7acc65528922efe573a12affe00f7be4ed37309fba"
    sha256 cellar: :any,                 sonoma:        "d92539860c22d368cc5a208b3c04053f5d6f047d25647b3f0dbc8a4c8a55c70c"
    sha256 cellar: :any,                 ventura:       "9fb489755752aa7decd8ec2f38dded60cdb7dcbde86377153d8b6953e511ac6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87bd6039d932ef08d8b6b42d4adc44f497e54eb4ba9b153a44e439646b30209"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg@6" # Issue ref: https://github.com/bavc/qctools/issues/552
  depends_on "qt"
  depends_on "qwt"

  uses_from_macos "zlib"

  def install
    ENV["USE_BREW"] = "true"

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
    system Formula["ffmpeg@6"].bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath/"video.mp4.qctools.xml.gz"
    system bin/"qcli", "-i", mp4out, "-o", qcliout
    assert_path_exists qcliout
  end
end
