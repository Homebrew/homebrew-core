class Libupnp < Formula
  desc "The portable Universal Plug and Play (UPnP) SDK"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.8.3/libupnp-1.8.3.tar.bz2"
  sha256 "9afa0b09faa9ebd9e8a6425ddbfe8d1d856544c49b1f86fde221219e569a308d"

  bottle do
    cellar :any
    sha256 "cbca37b45cb652c73d4c5ae0ae087338bb4c606f5be4306c5d998c39c382bb4b" => :high_sierra
    sha256 "b870845572dd6d11ed90fedfb367bbd53066f6b9c90e522b97ce88ae53ccddfe" => :sierra
    sha256 "9b660881232e6ce94a375962c1df55f179f69335c7d11907b9a9c5dd81693360" => :el_capitan
  end

  option "without-ipv6", "Disable IPv6 support"
  option "without-reuseaddr", "Disable reuseaddr support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-ipv6" if build.with? "ipv6"
    args << "--enable-reuseaddr" if build.with? "reuseaddr"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include "upnp.h"
      #include <stdio.h>
      #include <stdlib.h>

      int
      main (int argc, char* argv[])
      {
        int rc;
        rc = UpnpInit (NULL, 0);
          if ( UPNP_E_SUCCESS == rc ) {
            printf ("UPnP Initializes OK");
          } else {
            printf ("** ERROR UpnpInit(): %d", rc);
            exit (EXIT_FAILURE);
          }
          (void) UpnpFinish();
          exit (EXIT_SUCCESS);
      }
    EOS
    system ENV.cc, "-I#{include}/upnp", "-lupnp",
           testpath/"test.cc", "-o", testpath/"test"

    assert_equal "UPnP Initializes OK",
            shell_output(testpath/"test").strip,
            "UPnP Initializes OK"
  end
end
