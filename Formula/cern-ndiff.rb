class CernNdiff < Formula
  desc "Numerical diff tool"
  # Note: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "http://svn.cern.ch/guest/madx/tags/5.02.11/madX/tools/numdiff"
  head "http://svn.cern.ch/guest/madx/trunk/madX/tools/numdiff"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d9d4e7b36137b7cdef5f3f5b63e8ec33400766c8d104e3f8849d8eb3781d804" => :sierra
    sha256 "8e7e455e086ec860d08e709b2db00da57a70a9275e5060f4969cd145fa624c56" => :el_capitan
    sha256 "4f6e84d404a05431989edeb723416692489e891b02d5379e3d06e1230c07ec09" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")
    system "#{bin}/ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
