class ClapHost < Formula
  desc "CLAP example host"
  homepage "https://github.com/free-audio/clap-host"
  url "https://github.com/free-audio/clap-host.git",
        tag: "1.0.1",
        revision: "4602d26b91a526ac80933bdc9f6fcafdf2423bbf"
  license "MIT"
  head "https://github.com/free-audio/clap-host.git", branch: "main"

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "rtaudio"
  depends_on "rtmidi"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCLAP_HOST_BUNDLE=FALSE", *std_cmake_args
    system "cmake", "--build", "build", "--target", "clap-host"
    system "cmake", "--install", "build"
  end

  test do
    system "clap-host", "--help"
  end
end
