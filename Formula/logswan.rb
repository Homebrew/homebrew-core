class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.8.tar.gz"
  sha256 "b3201d3f8a9863d51a0c3caec9e89c74dab8de7a604a5761454df64c30908ef8"
  license "BSD-2-Clause"

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
