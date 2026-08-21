class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://github.com/gammu/gammu/releases/download/1.44.1/Gammu-1.44.1.tar.gz"
  sha256 "59876301ed7556c909b656b09c07d9d43ef167eba1ae976175710024188f053d"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6ba632ae130339512b36d44aa4edd45f07644a6f96e2c17680cb1afb4338ab75"
    sha256 arm64_sequoia: "fcfc3cd0d52f54de9006b306c77a1b482585781f9fd8856f5f42401c2b59b0a8"
    sha256 arm64_sonoma:  "25e598940d6a204c28f1b4a6467baef9d43573cd04cfd9184b8114deecc7c816"
    sha256 sonoma:        "15f0d17e675bf02aed63e8903ef168b7944cc4d0faa7aa2d89d90bcb4b3a0cb9"
    sha256 arm64_linux:   "7dbd3a9ec24fec4a4aac3589de5db0590688084f36492674cd49ca878cd074e3"
    sha256 x86_64_linux:  "8b663a772f2d96bc76548e0347a6b6f9c2aa197fc995734edf00b2ced27a3fb1"
  end

  depends_on "cmake" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_Postgres=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end
