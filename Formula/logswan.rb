class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.8.tar.gz"
  sha256 "b3201d3f8a9863d51a0c3caec9e89c74dab8de7a604a5761454df64c30908ef8"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "dea1726c54eb9acaf4745a9cf67e46992ce6d8d7651b1f47faa76df225d831f4" => :big_sur
    sha256 "844574a208157568c6e3b320a6be97f48fe1138340bed1eb465d223ae4dd50de" => :catalina
    sha256 "bb06c502e3d6ecb4dba59130e58465e1b91f5848eb5d42b04ba609877e34ba91" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
