class Aspcud < Formula
  desc "Package dependency solver"
  homepage "https://potassco.org/aspcud/"
  url "https://github.com/potassco/aspcud/archive/v1.9.4.tar.gz"
  sha256 "3645f08b079e1cc80e24cd2d7ae5172a52476d84e3ec5e6a6c0034492a6ea885"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 "5696aa5e1520bbdb4d6c279944325ab6b2bc0e0b109e648037bbec0aad880938" => :big_sur
    sha256 "3271ff048eea3fb3bbf5b22b8f59bce767362cf2b5e15935be0b407fba8914fd" => :catalina
    sha256 "3363c5cfa7f9ad4dd35ddb172c5eb878a504000bae59a477e5ea9246fe27680a" => :mojave
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "clingo"

  # Fix for compatibility with Boost >= 1.74
  # https://github.com/potassco/aspcud/issues/7
  patch :DATA

  def install
    args = std_cmake_args
    args << "-DASPCUD_GRINGO_PATH=#{Formula["clingo"].opt_bin}/gringo"
    args << "-DASPCUD_CLASP_PATH=#{Formula["clingo"].opt_bin}/clasp"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"in.cudf").write <<~EOS
      package: foo
      version: 1

      request: foo >= 1
    EOS
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
__END__
diff -pur aspcud-1.9.4-old/libcudf/src/dependency.cpp aspcud-1.9.4/libcudf/src/dependency.cpp
--- aspcud-1.9.4-old/libcudf/src/dependency.cpp	2017-09-19 12:48:41.000000000 +0200
+++ aspcud-1.9.4/libcudf/src/dependency.cpp	2020-11-17 15:39:33.000000000 +0100
@@ -473,7 +473,7 @@ void ConflictGraph::cliques_(bool verbos
         }
         else {
             PackageList candidates = component, next;
-            boost::sort(candidates, boost::bind(&ConflictGraph::edgeSort, this, _1, _2));
+            boost::sort(candidates, boost::bind(&ConflictGraph::edgeSort, this, boost::placeholders::_1, boost::placeholders::_2));
             // TODO: sort by out-going edges
             do {
                 cliques.push_back(PackageList());
