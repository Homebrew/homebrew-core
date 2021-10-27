class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.6.3.tar.xz"
  sha256 "daf91a63f58dd157ca340c457871e66260cb9c3333fefb008b318befbb0e081a"
  license "LGPL-2.1"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8547a058752a4a107227a379565968ca1240846464ebcc85478ea986f3a14caf"
    sha256 cellar: :any,                 arm64_big_sur:  "80b085f93f8bd5a189b65ef9f9792d1070a3e2743d5b0d80fea37320a05f7821"
    sha256 cellar: :any,                 monterey:       "d002852d72c7721ff49ad67cb21052d4b584e459372802082b1a725353409fed"
    sha256 cellar: :any,                 big_sur:        "f1ec19e1e09fcb4b56f08701419e43e0f70f2551ef5584510b26c29cac3b4f34"
    sha256 cellar: :any,                 catalina:       "8c1331e57e66489ba3488e44e70860c645f0c2739d5b34ec82be45fc42985d7a"
    sha256 cellar: :any,                 mojave:         "c3f5c74b93b7b71755e104c8c62d0ac8f10b36ca579210729e654706e83f1e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae37f837221f686dd5ebb8cdcb59a0e0fede7db02f7cbc5b374c3e44019e8f9"
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
