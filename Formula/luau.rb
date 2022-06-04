class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.530.tar.gz"
  sha256 "913dd66657f1c65c592e85443100bd89c5259f3df3ba86c8cd26d51296a8f42d"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eea01023190fef7e90fb1072f8dcdd2f90d109122ce21e63fca30cb1a2dd0c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c0ba154c087b9df32ef7e29e905c3c6c7b656a8187fb16f7de008e16b27d0d"
    sha256 cellar: :any_skip_relocation, monterey:       "c8e0bf93ec7e712c84e82ea73c62af69ad971bd1884a746c5c7e877861054887"
    sha256 cellar: :any_skip_relocation, big_sur:        "b67ff7eb168c46e3f99947fe0e4e0b1d7462ff2de4e750e9a9e2bd23f1e49f28"
    sha256 cellar: :any_skip_relocation, catalina:       "ad0a04c510b1bdc5704f2785768e24a7bab04db6659e0e3c3ed16e033669a683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72f035abdbf2d09b3000916174adc2c3b4788137e5849f0cbebee1fb2ef1fec9"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Upstreamed here: https://github.com/Roblox/luau/pull/522.
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DLUAU_BUILD_TESTS=OFF"
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end

__END__
diff --git a/Analysis/include/Luau/Variant.h b/Analysis/include/Luau/Variant.h
index c9c97c9..f637222 100644
--- a/Analysis/include/Luau/Variant.h
+++ b/Analysis/include/Luau/Variant.h
@@ -6,6 +6,7 @@
 #include <type_traits>
 #include <initializer_list>
 #include <stddef.h>
+#include <utility>

 namespace Luau
 {
