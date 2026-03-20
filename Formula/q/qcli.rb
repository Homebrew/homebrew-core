class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools.git",
      tag:      "v1.4",
      revision: "982619270ff49987328343909ea2179d1af52004"
  license "GPL-3.0-or-later"
  head "https://github.com/bavc/qctools.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "e05bc0c79aae6f0fe1a9d888e36e9d046550df0885eb4f16a0f3e9d39b6db1fc"
    sha256 cellar: :any,                 arm64_sequoia: "589146936f71fffb6c0ef28b9f7a5e49041f2b6aa66a31029974ebf601876a2d"
    sha256 cellar: :any,                 arm64_sonoma:  "1d9eb1a313c8d47a08709838a13d3d376ee484e65bb5835982d857ec232aca86"
    sha256 cellar: :any,                 sonoma:        "51ec32892dfaf29f0ba4870f9fb1871f7f9053d6226002b79d76bdc9d0276097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "266ba78a5f9da200e9ce2a3f1d857f6267e3cecbca8c5dc34b72a26b89128484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "470749fbaafaa552f2398c6937d878609142c5c701ba1b3fa37bde12f98b8432"
  end

  depends_on "pkgconf" => :build
  depends_on "qtmultimedia" => :build
  depends_on "qwt" => :build
  depends_on "ffmpeg@6" # Issue ref: https://github.com/bavc/qctools/issues/552
  depends_on "qtbase"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
