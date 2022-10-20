class Libvncserver < Formula
  desc "VNC server and client libraries"
  homepage "https://libvnc.github.io"
  url "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.13.tar.gz"
  sha256 "0ae5bb9175dc0a602fe85c1cf591ac47ee5247b87f2bf164c16b05f87cbfa81a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^LibVNCServer[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "819203d759df0243fafbe98a4af39ceb66df276ec292d774b79e1292a1b565af"
    sha256 cellar: :any,                 arm64_big_sur:  "2bc993923fe1854ab86f96e2644f1ae865b538b09092cafabe7bf4baadde2940"
    sha256 cellar: :any,                 monterey:       "9b4871a1a52f0f44d58bc57736490a44774738133cfe0b2ff92a6a86380d79f2"
    sha256 cellar: :any,                 big_sur:        "a28d45216831ec31a87e0756fd13fd226b9341b2bfa798acc865be3f34a530ac"
    sha256 cellar: :any,                 catalina:       "c667ff09ee40d2ab0e8db25a51697ae62edd14496c1075f07015bf0ed372695e"
    sha256 cellar: :any,                 mojave:         "7e5799814cd2077d39c8d4c95806fa23c408d8a26c92140ba64f852b6a53567f"
    sha256 cellar: :any,                 high_sierra:    "f331a9fc3ba043f0febe78df7551630a5a28f9adb362a58384901192476dff89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d354f5da00e9fb92f82c6766245eca86b4a21be88c26ceed615e871618e5a51e"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}
      -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/#{shared_library("libjpeg")}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "ctest", "-V"
      system "make", "install"
    end
  end

  test do
    (testpath/"server.cpp").write <<~EOS
      #include <rfb/rfb.h>
      int main(int argc,char** argv) {
        rfbScreenInfoPtr server=rfbGetScreen(&argc,argv,400,300,8,3,4);
        server->frameBuffer=(char*)malloc(400*300*4);
        rfbInitServer(server);
        return(0);
      }
    EOS

    system ENV.cc, "server.cpp", "-I#{include}", "-L#{lib}",
                   "-lvncserver", "-o", "server"
    system "./server"
  end
end
