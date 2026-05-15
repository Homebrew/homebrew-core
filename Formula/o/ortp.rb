class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.115/ortp-5.4.115.tar.bz2"
  sha256 "a8ae49c52e9351d9942cb031c6fe2d976dd518bad81171ae5737d288e32520f7"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8a9e668be34252876565b19339910d828446d66fccf320922dcf770c65622ec"
    sha256 cellar: :any,                 arm64_sequoia: "e805b8885495bc4f3fb8be8e56f8aec12cb6d33aaa81ec276356b24ce48869da"
    sha256 cellar: :any,                 arm64_sonoma:  "27e34fee8c9cf06f8d1c10c1e5c57539e0afc802a6102130f219724facf8a99f"
    sha256 cellar: :any,                 sonoma:        "04b6b25dd413f3511c705297132921baefc70893efd87a2ca67d0ef7f9d2e687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c64ffb0922a4478ea6e2390f1b39cef00564199982c39ba89e290791508c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9f8ae682a9839c024a8b6b971de0a1c7934ffd77afbf0da647b5b6e4802532"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.115/bctoolbox-5.4.115.tar.bz2"
    sha256 "3b3abe1c648b58bcded06e77714b52e46a5b24095c625b54b05ffade978f23f1"

    livecheck do
      formula :parent
    end
  end

  def install
    if build.stable?
      odie "bctoolbox resource needs to be updated" if version != resource("bctoolbox").version
      (buildpath/"bctoolbox").install resource("bctoolbox")
    else
      rm_r("external")
    end

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_MBEDTLS=OFF
      -DENABLE_OPENSSL=ON
      -DENABLE_TESTS_COMPONENT=OFF
    ]

    system "cmake", "-S", "bctoolbox", "-B", "build_bctoolbox", *args, *std_cmake_args
    system "cmake", "--build", "build_bctoolbox"
    system "cmake", "--install", "build_bctoolbox"
    prefix.install "bctoolbox/LICENSE.txt" => "LICENSE-bctoolbox.txt"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{frameworks}" if OS.mac?

    system "cmake", "-S", (build.head? ? "ortp" : "."), "-B", "build_ortp", *args, *std_cmake_args
    system "cmake", "--build", "build_ortp"
    system "cmake", "--install", "build_ortp"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", *linker_flags
    system "./test"
  end
end
