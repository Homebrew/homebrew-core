class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v6.1.0.tar.gz"
  sha256 "a0b6107372125f756783bf6e5d57d24e2c8330a4941f4c72e8ddcf13c31618ed"
  revision 2

  bottle do
    cellar :any
    sha256 "525a7514af0f5104afda2edcdcd9d8fff687aea7147d97024b57f2eac4d77f2e" => :mojave
    sha256 "d1caa4407556007dfb7e9122b1a473c2466357e91fa37812fb9f407159b959fa" => :high_sierra
    sha256 "113b891093b364bd479ea9af644d24379debd158f1f21a2f4e1b0018fd0c20d3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "gettext"
  depends_on "openssl@1.1"

  # patch submitted upstream at https://github.com/Azure/azure-storage-cpp/pull/261
  patch :DATA

  def install
    system "cmake", "Microsoft.WindowsAzure.Storage",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <was/common.h>
      #include <was/storage_account.h>
      using namespace azure;
      int main() {
        utility::string_t storage_connection_string(_XPLATSTR("DefaultEndpointsProtocol=https;AccountName=myaccountname;AccountKey=myaccountkey"));
        try {
          azure::storage::cloud_storage_account storage_account = azure::storage::cloud_storage_account::parse(storage_connection_string);
          return 0;
        }
        catch(...){ return 1; }
      }
    EOS
    flags = ["-stdlib=libc++", "-std=c++11", "-I#{include}",
             "-I#{Formula["boost"].include}",
             "-I#{Formula["openssl@1.1"].include}",
             "-I#{Formula["cpprestsdk"].include}",
             "-L#{Formula["boost"].lib}",
             "-L#{Formula["cpprestsdk"].lib}",
             "-L#{Formula["openssl@1.1"].lib}",
             "-L#{lib}",
             "-lcpprest", "-lboost_system-mt", "-lssl", "-lcrypto", "-lazurestorage"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_azurestoragecpp", "test.cpp", *flags
    system "./test_azurestoragecpp"
  end
end

__END__
diff --git a/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake b/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake
index 9171f8c..a427288 100644
--- a/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake
+++ b/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake
@@ -63,6 +63,12 @@ else (UUID_LIBRARIES AND UUID_INCLUDE_DIRS)
       /usr/freeware/lib64
   )

+  if (APPLE)
+    if (NOT UUID_LIBRARY)
+      set(UUID_LIBRARY  "")
+    endif (NOT UUID_LIBRARY)
+  endif (APPLE)
+
   find_library(UUID_LIBRARY_DEBUG
     NAMES
       uuidd
@@ -88,9 +94,9 @@ else (UUID_LIBRARIES AND UUID_INCLUDE_DIRS)
   set(UUID_INCLUDE_DIRS ${UUID_INCLUDE_DIR})
   set(UUID_LIBRARIES ${UUID_LIBRARY})

-  if (UUID_INCLUDE_DIRS AND UUID_LIBRARIES)
+  if (UUID_INCLUDE_DIRS AND (APPLE OR UUID_LIBRARIES))
      set(UUID_FOUND TRUE)
-  endif (UUID_INCLUDE_DIRS AND UUID_LIBRARIES)
+  endif (UUID_INCLUDE_DIRS AND (APPLE OR UUID_LIBRARIES))

   if (UUID_FOUND)
     if (NOT UUID_FIND_QUIETLY)
