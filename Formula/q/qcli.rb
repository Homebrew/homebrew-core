class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools.git",
      tag:      "v1.4",
      revision: "982619270ff49987328343909ea2179d1af52004"
  license "GPL-3.0-or-later"
  head "https://github.com/bavc/qctools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:  "cf444e12eb4d646d9b80a325aec6df56361d9dd39ce2e80d90906f0916117dde"
    sha256 cellar: :any,                 arm64_sonoma: "fb63a2f6ab9e1bb330fc899b52228665b941e42a9201958f9d0594df19a384ad"
    sha256 cellar: :any,                 sonoma:       "dbac2e76a60e184f4fec01ff89c988bc5e6c6908ca3f675569749a6ba77d4ae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7d480d344f4e4241e95030eef80d7d38440d9079f68d3c35f6707b8dd4a29372"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb6419243bf6240de5d24047020a8ef6eebef3f43c8adc5c00fbecbf19f3bf2c"
  end

  depends_on "pkgconf" => :build
  depends_on "qtmultimedia" => :build
  depends_on "qwt" => :build
  depends_on "ffmpeg@6" # Issue ref: https://github.com/bavc/qctools/issues/552
  depends_on "qtbase"

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
