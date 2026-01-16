class Libxkbfile < Formula
  desc "X.Org: XKB file handling routines"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libxkbfile-1.1.3.tar.xz"
  sha256 "a9b63eea997abb9ee6a8b4fbb515831c841f471af845a09de443b28003874bec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ad78e28e658fe619042b00e3e372fda42a489eda6546d1e465d0de004a32c81a"
    sha256 cellar: :any,                 arm64_sequoia:  "e66ffd78987318c3f579f3afb3e8356d086edcdd6dfde914e94b3fb047b65117"
    sha256 cellar: :any,                 arm64_sonoma:   "cb79bbe025a76e58fd15adee3bf20ee3efd8103a578d2e6139358c1f9cd7a8fd"
    sha256 cellar: :any,                 arm64_ventura:  "c5ad9490a09538b6a72372d8716a424ebbecf777c2a1ea5d448fcefe950a78c9"
    sha256 cellar: :any,                 arm64_monterey: "6ef647b8fbac800454607ac21aac57a9264a4c5a2cb912afb34671f5c6a6ab0a"
    sha256 cellar: :any,                 sonoma:         "0a17cc951fb5fca888c90ba27f8f9dfb9696a00984f02772d6aca1dde438abcc"
    sha256 cellar: :any,                 ventura:        "0f9bc440b8317515984e5aefd9a1ad1f6e9c72c2882c94af5d91fb6df20f3e7c"
    sha256 cellar: :any,                 monterey:       "182270371f7c7b1c6f7ccd0e9712c947c64d80391d12ab7561c614d89d7ae307"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e3ec817afdb538ad032d91648d53da21c4d9033dde8c117410381577c19db407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5298209c95e682bf215c5335aa140c4e0249f68aa2d086f058c42f5fc5446197"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <X11/XKBlib.h>
      #include "X11/extensions/XKBfile.h"

      int main(int argc, char* argv[]) {
        XkbFileInfo info;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
