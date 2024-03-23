class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.2.0/libimobiledevice-glue-1.2.0.tar.bz2"
  sha256 "ff9cbc240c9780edfa43914a057b86362054053721b65fb04f54a25023b92b62"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b74bcad7552e908d4316003e45cc73c78044d731dba62f3b001f40071af929c"
    sha256 cellar: :any,                 arm64_ventura:  "433268545b39dc520f40bea9a91008a1fffda62a07b89cd48c2428b687da25af"
    sha256 cellar: :any,                 arm64_monterey: "6475e64862a87b0d00bc8802431a749500338ee6f9f29ae1bd8687cd6a0dc35a"
    sha256 cellar: :any,                 sonoma:         "b0b2a8a38b9d914c104c9c3605bc6ea1a024691454fc516b235f61b1be020ec8"
    sha256 cellar: :any,                 ventura:        "a2892bbecd5d4749d4033aa1b6cb32c3ead41501d3e78c30df0f0c52a43f69e2"
    sha256 cellar: :any,                 monterey:       "908985a605303768e061d3b9a0459545f1507b75010f6d837683dfb42e50d07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099ed15275491d9cf7cf96a0f501c037af6bd1a393f7631def24d3c05275eb69"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    else
      system "./configure", *std_configure_args, "--disable-silent-rules"
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    system "./test"
  end
end
