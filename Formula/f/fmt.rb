class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/refs/tags/10.2.1.tar.gz"
  sha256 "1250e4cc58bf06ee631567523f48848dc4596133e163f02615c97f78bab6c811"
  license "MIT"
  revision 1
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "666aae4a2019ed7957e96ed6e6d182db676a2088a7b1646bb0a1ad48809fe571"
    sha256 cellar: :any,                 arm64_ventura:  "3316fbda0bed3dd713f2045c3fefa14fead6fe1a11c58c55262dee93a40e2bda"
    sha256 cellar: :any,                 arm64_monterey: "80d218961620251763fcaac82ae04ce2d604ad6c86cd19ae0320c54ba7b1b0f4"
    sha256 cellar: :any,                 sonoma:         "c193bef5f45e097a20c2b622dee0347dc76a8e1fe49de12297f5803ab2b2f977"
    sha256 cellar: :any,                 ventura:        "772fed0ecbf537c7a55d768b380363324e815c7805dfc4322749abdc4ebdeb9e"
    sha256 cellar: :any,                 monterey:       "5ed3d39677cf4bec72c05cd8ae62adf102b38ba82dcdea545f41f3a1dea39443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd75f94114953993f1a36280918192dae764319c3f8e2f54e875d9f8266848f0"
  end

  depends_on "cmake" => :build

  # Fix handling of static separator; cherry-picked from:
  # https://github.com/fmtlib/fmt/commit/44c3fe1ebb466ab5c296e1a1a6991c7c7b51b72e
  # Remove when included in a release.
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end

__END__
diff --git a/include/fmt/format-inl.h b/include/fmt/format-inl.h
index 9fc87ecf2027df0346935e7666ea80ec70e65575..872aa9802df1ffa8572a2f0d29f58bdb2b171a1a 100644
--- a/include/fmt/format-inl.h
+++ b/include/fmt/format-inl.h
@@ -110,7 +110,11 @@ template <typename Char> FMT_FUNC Char decimal_point_impl(locale_ref) {
 
 FMT_FUNC auto write_loc(appender out, loc_value value,
                         const format_specs<>& specs, locale_ref loc) -> bool {
-#ifndef FMT_STATIC_THOUSANDS_SEPARATOR
+#ifdef FMT_STATIC_THOUSANDS_SEPARATOR
+  value.visit(loc_writer<>{
+      out, specs, std::string(1, FMT_STATIC_THOUSANDS_SEPARATOR), "\3", "."});
+  return true;
+#else
   auto locale = loc.get<std::locale>();
   // We cannot use the num_put<char> facet because it may produce output in
   // a wrong encoding.
@@ -119,7 +123,6 @@ FMT_FUNC auto write_loc(appender out, loc_value value,
     return std::use_facet<facet>(locale).put(out, value, specs);
   return facet(locale).put(out, value, specs);
 #endif
-  return false;
 }
 }  // namespace detail
 
