class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.2.0.tar.gz"
  sha256 "d06d8f31a62e5d2903a8ccf07696e02cadf4de2024dc3b558d410d913c81dbef"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dfa67df172bd561c0273e59f30b02064467ddbde0f4f37ae5e000efdc0d98f5" => :el_capitan
    sha256 "4b9ffad5a523b83dc7a6c5379d201c55becad69eec015767edfd29e205fd4429" => :yosemite
    sha256 "712456308a7cf5216752036b9d7ae535ae814f865099ff0436689eafcbebc085" => :mavericks
  end

  option "with-debug", "Build with debug symbols"

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "boost" => :build
  depends_on "ragel" => :build
  depends_on "cmake" => :build

  # workaround for freebsd/clang/libc++ build issues
  # https://github.com/01org/hyperscan/issues/27
  # https://github.com/01org/hyperscan/commit/e9cfbae68f69b06bb4fdcd2abd7c1ee5afec0262
  patch :DATA

  def install
    mkdir "build" do
      args = std_cmake_args

      if build.with? "debug"
        args -= %w[
          -DCMAKE_BUILD_TYPE=Release
          -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG
          -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
        ]
        args += %w[
          -DCMAKE_BUILD_TYPE=Debug
          -DDEBUG_OUTPUT=on
        ]
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/src/parser/ComponentRepeat.cpp b/src/parser/ComponentRepeat.cpp
index ff02703..74aa590 100644
--- a/src/parser/ComponentRepeat.cpp
+++ b/src/parser/ComponentRepeat.cpp
@@ -184,7 +184,7 @@ void ComponentRepeat::notePositions(GlushkovBuildState &bs) {

 vector<PositionInfo> ComponentRepeat::first() const {
     if (!m_max) {
-        return {};
+        return vector<PositionInfo>();
     }

     assert(!m_firsts.empty()); // notePositions should already have run
diff --git a/src/rose/rose_build_misc.cpp b/src/rose/rose_build_misc.cpp
index b16e3a6..1977f92 100644
--- a/src/rose/rose_build_misc.cpp
+++ b/src/rose/rose_build_misc.cpp
@@ -880,7 +880,7 @@ namespace {
 class OutfixAllReports : public boost::static_visitor<set<ReportID>> {
 public:
     set<ReportID> operator()(const boost::blank &) const {
-        return {};
+        return set<ReportID>();
     }

     template<class T>
