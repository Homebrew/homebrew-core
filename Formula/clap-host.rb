class ClapHost < Formula
  desc "CLAP example host"
  homepage "https://github.com/free-audio/clap-host"
  url "https://github.com/free-audio/clap-host", using: :git, tag: "v0.2", revision: "67111309ea1bbedb6f7bf8b1b8b99359d90d09cc"
  license "MIT"
  head "https://github.com/free-audio/clap-host", using: :git, branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "rtaudio"
  depends_on "rtmidi"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCLAP_HOST_BUNDLE=FALSE", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    system "true"
  end
end
