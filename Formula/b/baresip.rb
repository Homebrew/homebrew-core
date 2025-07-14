class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "a6dc7d76714236cbf64b9f58ece742befcd9e40bc787b0173370d52fd0447eb4"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "d451822ece91b2c2187cbe2287ce5dae225b87bef5e5b2e86da57f3731adaa94"
    sha256 arm64_sonoma:  "308af3cc60ea91ae71e517ac56d006695bba6e7c36019d57c137f1db948ecebc"
    sha256 arm64_ventura: "43749b6c8bf6a81f09e6d3e91878010c7b5bee214a28ccdd4d3a00db7b8b32d6"
    sha256 sonoma:        "58ac657f3f9959783904903c435c9623712d1a21cfa4031abeebc249fff2dee3"
    sha256 ventura:       "6f58d8464e5a05522d9a220e563602f128e9a716e3f291c8f4624c8a1597b916"
    sha256 arm64_linux:   "ff0516a389f607cc0fe2e72b9160ac2886acb1da4ec46454e0fcbf0720aa885f"
    sha256 x86_64_linux:  "ac876418825ae50774d526ea0594b136910d3957c823ebda24cf33d182bacc7f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
