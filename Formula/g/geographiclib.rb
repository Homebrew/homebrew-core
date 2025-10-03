class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.6.tar.gz"
  sha256 "6cf42e3477c295c184945a16e9f80b76d5b1a42704bec849928530d968bfc059"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6daafba69993f538bac76f6bc95d3947c6aac80ce4e327a6ed4632ce853e300"
    sha256 cellar: :any,                 arm64_sequoia: "85bf3a443598e3e6591c9e3fe65ab9e4ae6d0def72de3227a5b0f05b955d2403"
    sha256 cellar: :any,                 arm64_sonoma:  "36054edc5ead5d58705b9abc937c79e7c4a846a2855f951339813f36f7213186"
    sha256 cellar: :any,                 sonoma:        "1865b4e7137f56724bb11ef49dc7cf7fb1fe37a0e9dbcb5cfae3a3860528e3cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "292d82ffc4f8815838c1de87b0aca307ab71c0ffa8529f5247080aeab8216906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27125a5451388fa40df4089884aed7f793fdce743bcc29f15e8d7382043510cb"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DEXAMPLEDIR="]
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
