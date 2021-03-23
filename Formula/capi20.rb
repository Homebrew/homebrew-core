class Capi20 < Formula
  desc "Handle requests from CAPI-driven applications via FRITZ!Box routers"
  homepage "https://www.tabos.org"
  url "https://gitlab.com/tabos/libcapi/-/archive/v3.2.3/libcapi-v3.2.3.tar.bz2"
  sha256 "e0fcf2e8a59a0b64316e7da671c3a726c3aca22602f65a6679442535fe270f98"
  license "LGPL-2.1-only"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      -Denable-post-install=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja"
      system "ninja", "install"
    end

    # meson-internal gives wrong install_names for dylibs due to their unusual installation location
    # create softlinks to fix
    ln_s Dir.glob("#{lib}/capi20/*dylib"), lib
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <capi20.h>
      int main() {
        unsigned applid = capi_alloc_applid(0);
        int ok = !capi_validapplid(applid);
        capi_freeapplid(applid);
        return ok;
      }
    EOS
    flags = %W[
      -L#{lib}
      -lcapi20
    ]
    system ENV.cc, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
