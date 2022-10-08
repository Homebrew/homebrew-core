class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.7.1.tar.xz"
  sha256 "572a3033b8d93d48a6a858e514abce4b2f7a946fe1f02cbfeca39bfd703018b3"
  license "LGPL-2.1"
  head "https://github.com/Matroska-Org/libmatroska.git", branch: "master"

  livecheck do
    url "https://dl.matroska.org/downloads/libmatroska/"
    regex(/href=.*?libmatroska[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b8a93025aa493a3337c60587f4b0d44ed1405444928a654bf5bd4da5e97b7630"
    sha256 cellar: :any,                 arm64_big_sur:  "bb1ddb052d3a72306f3e0b144375a51e773d662f33c7f32c5fd6b5d3ab367ee2"
    sha256 cellar: :any,                 monterey:       "e810f9fd1cde2dc589d5c8f8a90e5b83731f5d11b1dffdb7bde18766f1aecf33"
    sha256 cellar: :any,                 big_sur:        "d5f12efa4d18b6d752a454fc1693d14fd8c8f73d07fee1af29906d0f012ec98a"
    sha256 cellar: :any,                 catalina:       "b540d3cba51677fa0bcf8814044cc3c1e3e5deac86d9d92652967e3832a48949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88cf397ff4c9039c616418a7ddde0b298b30fd586496de95c9ccd265b1c6cd0a"
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
