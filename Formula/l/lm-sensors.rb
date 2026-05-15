class LmSensors < Formula
  desc "Tools for monitoring the temperatures, voltages, and fans"
  homepage "https://github.com/hramrach/lm-sensors"
  url "https://github.com/hramrach/lm-sensors/archive/refs/tags/V3-6-2.tar.gz"
  version "3.6.2"
  sha256 "c6a0587e565778a40d88891928bf8943f27d353f382d5b745a997d635978a8f0"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_linux:  "05d1a0969a84d7ed3f9b95effe63bc9378452f2a1a1e367b8c8ef1efde275af9"
    sha256 x86_64_linux: "24aa125e2b8fe32e1600b64c0c5d8a32a575db9ef4dea9e17d31c6a02a48087f"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on :linux

  def install
    args = %W[
      PREFIX=#{prefix}
      BUILD_STATIC_LIB=0
      MANDIR=#{man}
      ETCDIR=#{prefix}/etc
    ]
    system "make", *args
    system "make", *args, "install"
  end

  test do
    assert_match("Usage", shell_output("#{bin}/sensors --help"))
  end
end
