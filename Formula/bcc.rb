class Bcc < Formula
  desc "Tools for BPF-based Linux IO analysis, networking, monitoring, and more"
  homepage "https://github.com/iovisor/bcc"
  url "https://github.com/iovisor/bcc/releases/download/v0.24.0/bcc-src-with-submodule.tar.gz"
  sha256 "4ff35d71f1dc3b6fc5626bbb7644afc9eb0953be23e873c61034c8f50c589268"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "make" => :build
  depends_on "arping"
  depends_on "bison"
  depends_on "flex"
  depends_on "iperf"
  depends_on :linux
  depends_on "linux-headers@5.16"
  depends_on "luajit"
  depends_on "netperf"
  depends_on "python@3.9"
  depends_on "zlib"

  def install
    ENV.deparallelize
    mkdir "build"
    chdir "build" do
      system "cmake", "--install-prefix=#{HOMEBREW_PREFIX}", "-DPYTHON_CMD=python3", ".."
      system "make"
      system "make", "install"
      # chdir "src/python" do
      #  system "make"
      #  system "make", "install"
      # end
    end
  end

  test do
    system "true"
  end
end
