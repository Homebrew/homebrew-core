class Dfc < Formula
  desc "Display graphs and colors of file system space/usage"
  homepage "https://projects.gw-computing.net/projects/dfc"
  url "https://projects.gw-computing.net/attachments/download/615/dfc-3.1.1.tar.gz"
  sha256 "962466e77407dd5be715a41ffc50a54fce758a78831546f03a6bb282e8692e54"
  head "https://github.com/Rolinh/dfc.git"

  bottle do
    sha256 "1d5e990bb866fcb44bbbe3ac9e959402fc1f5c7fd3ad0df5b5ac1da0b3453a35" => :mojave
    sha256 "11d5691f5ca6020dfb6cdb084529c1d9caa4be674da27fa2d395adaccd799f56" => :high_sierra
    sha256 "029104b15817e039032593cb9828b76f42f4362b63eeb7d582c7d0d90fc917b8" => :sierra
    sha256 "bd407f57305b87838f0083c5a3d65493a76097fda65f4ffeebacfbcf33baeddf" => :el_capitan
    sha256 "ba254d9a1213beb84728657e996c667eb9a87f61ea118d12cf022b389a2e35b0" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gettext"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"dfc", "-T"
    assert_match ",%USED,", shell_output("#{bin}/dfc -e csv")
  end
end
