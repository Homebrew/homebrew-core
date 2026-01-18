class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/refs/tags/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 13

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5ded8a98f510882bd5598fd1e80b8e050c11c4bf36b6608f61798be75df53b4"
    sha256 cellar: :any,                 arm64_sequoia: "5df2c310306afc25be4b8584dcfc35868fb2ef37ae3a93b078efb49f68dcca57"
    sha256 cellar: :any,                 arm64_sonoma:  "02d85ddbb40aeebcf8c58a979c5100f7eef443c8e177a4b72fbfddf8965d945b"
    sha256 cellar: :any,                 sonoma:        "8361fddb35351308959d4757449020dab407dc2a574c78c09963f20e7ea3699b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e769aace8ba7e7f1a100a666a80340bdd81bed6102c3120f901bebaaf8c55d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f883cfced0814e9f18b734fc1800042754e7022a395dd3e87342452e52e59cc0"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "libpng"

  uses_from_macos "zlib"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https://github.com/udoprog/c10t/pull/153
  patch do
    url "https://github.com/udoprog/c10t/commit/4a392b9f06d08c70290f4c7591e84ecdbc73d902.patch?full_index=1"
    sha256 "7197435e9384bf93f580fab01097be549c8c8f2c54a96ba4e2ae49a5d260e297"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https://github.com/udoprog/c10t/commit/2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/f7ab02089c43dd557ef4/raw/a0ae7974e635b8ebfd02e314cfca9aa8dc95029d/c10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https://github.com/udoprog/c10t/commit/800977bb23e6b4f9da3ac850ac15dd216ece0cda.patch?full_index=1"
    sha256 "c7a37f866b42ff352bb58720ad6c672cde940e1b8ab79de4b6fa0be968b97b66"
  end

  # Fix build with Boost 1.85.0, issue ref: https://github.com/udoprog/c10t/issues/313
  # Fix build with Boost 1.89.0, issue ref: https://github.com/udoprog/c10t/issues/315
  patch :DATA

  def install
    args = ["-DCMAKE_CXX_STANDARD=11", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"]
    unless OS.mac?
      args += %W[
        -DCMAKE_LINK_WHAT_YOU_USE=ON
        -DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}/libz.so.1
        -DZLIB_INCLUDE_DIR=#{Formula["zlib"].include}
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/c10t"
  end

  test do
    system bin/"c10t", "--list-colors"
  end
end

__END__
diff --git a/src/cache.hpp b/src/cache.hpp
index 958b283..f8ddb06 100644
--- a/src/cache.hpp
+++ b/src/cache.hpp
@@ -35,7 +35,7 @@ public:
   cache_file(const fs::path cache_dir, const fs::path source_path, bool cache_compress)
     : cache_dir(cache_dir), source_path(source_path), 
       cache_compress(cache_compress),
-      cache_path(cache_dir / (fs::basename(source_path) + ".cmap"))
+      cache_path(cache_dir / (source_path.stem().string() + ".cmap"))
   {
   }
   
@@ -44,7 +44,7 @@ public:
   }
   
   bool exists() {
-    return fs::is_regular(cache_path)
+    return fs::is_regular_file(cache_path)
       && fs::last_write_time(cache_path) >= fs::last_write_time(source_path);
   }
 
diff --git a/src/fileutils.hpp b/src/fileutils.hpp
index 3b8f2a7..45b0cfb 100644
--- a/src/fileutils.hpp
+++ b/src/fileutils.hpp
@@ -47,7 +47,7 @@ public:
             ++itr )
       {
         if (fs::is_directory(itr->status())) {
-          if (!filter(fs::basename(itr->path()))) {
+          if (!filter(itr->path().stem().string())) {
             continue;
           }
           
diff --git a/src/main.cpp b/src/main.cpp
index 78bd49c..5b539bd 100644
--- a/src/main.cpp
+++ b/src/main.cpp
@@ -1251,7 +1251,7 @@ int main(int argc, char *argv[]){
       
       if (s.use_split) {
         try {
-          boost::format(fs::basename(s.output_path)) % 0 % 0;
+          boost::format(s.output_path.stem().string()) % 0 % 0;
         } catch (boost::io::too_many_args& e) {
           error << "The `-o' parameter must contain two number format specifiers `%d' (x and y coordinates) - example: -o out/base.%d.%d.png";
           goto exit_error;
diff --git a/src/mc/utils.cpp b/src/mc/utils.cpp
index a1b3e0e..2ef6b3e 100644
--- a/src/mc/utils.cpp
+++ b/src/mc/utils.cpp
@@ -83,10 +83,10 @@ namespace mc {
         throw invalid_argument("not a regular file");
       }
       
-      string extension = fs::extension(path);
+      string extension = path.extension().string();
       
       std::vector<string> parts;
-      split(parts, fs::basename(path), '.');
+      split(parts, path.stem().string(), '.');
       
       if (parts.size() != 3 || extension.compare(".dat") != 0) {
         throw invalid_argument("level data file name does not match <x>.<z>.dat");
@@ -104,10 +104,10 @@ namespace mc {
         throw invalid_argument("not a regular file");
       }
       
-      string extension = fs::extension(path);
+      string extension = path.extension().string();
       
       std::vector<string> parts;
-      split(parts, fs::basename(path), '.');
+      split(parts, path.stem().string(), '.');
       
       if (parts.size() != 3 || extension.compare(".mcr") != 0) {
         throw invalid_argument("level data file name does not match <x>.<z>.mcr");
diff --git a/src/players.cpp b/src/players.cpp
index 21b0883..b4afef6 100644
--- a/src/players.cpp
+++ b/src/players.cpp
@@ -32,7 +32,7 @@ void register_double(player *p, std::string name, nbt::Double value) {
 
 player::player(const fs::path path) :
   path(path),
-  name(fs::basename(path)), grammar_error(false), in_pos(false),
+  name(path.stem().string()), grammar_error(false), in_pos(false),
   pos_c(0), xPos(0), yPos(0), zPos(0)
 {
   nbt::Parser<player> parser(this);
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3f1531a..280cb2b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -23,7 +23,7 @@ find_package(ZLIB REQUIRED)
 find_package(PNG REQUIRED)
 find_package(FreeType REQUIRED)
 find_package(Threads REQUIRED)
-find_package(Boost COMPONENTS thread filesystem system REQUIRED)
+find_package(Boost COMPONENTS thread filesystem REQUIRED)
 
 include_directories(${ZLIB_INCLUDE_DIR})
 include_directories(${PNG_INCLUDE_DIR})
