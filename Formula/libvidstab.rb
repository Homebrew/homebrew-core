class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz"
  sha256 "14d2a053e56edad4f397be0cb3ef8eb1ec3150404ce99a426c4eb641861dc0bb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b7ac4253cc77f49ab1770cd10932faa39fabb75a7a299129142fbba284deacc3" => :sierra
    sha256 "25aba597740cf9b793997d8fb1d741d97fe24948967c8d0c232ea55fa9f7839f" => :el_capitan
    sha256 "9c20b222d86c69f675ff12cdd23689009dc6c007fd5ee8db22d4195eca770ee1" => :yosemite
    sha256 "9b1e3aa9d03c9a5f3dcb0e4632ffe36ed2e1ccc131b7e5b977ea7143e33ce5af" => :mavericks
    sha256 "73077db3e1a9effb890277b6b20be38f20e6924704f5c8b347806f2527d14662" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DUSE_OMP=OFF", *std_cmake_args
    system "make", "install"
  end
end
