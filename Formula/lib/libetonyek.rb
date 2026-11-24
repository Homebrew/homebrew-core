class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.15.tar.xz"
  sha256 "ba81a37e1be25dcaf73035c4a3cc4787a1e053b3272b2383ed3dec899c6a884f"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "47cebc3e420799290297b76e9a81479b4e16f78cd441d14232662e1c3b21d1da"
    sha256 arm64_golden_gate: "f408c6d9d7268dfcde3ad4cb88515c70373f09939e1053f2c4217f608c62eb22"
    sha256 arm64_tahoe:       "a45ed8398054c802b66130e5f3793f1e8de954d48606bdc1db5a615bc8150432"
    sha256 arm64_sequoia:     "a3e09230ead3fa931e0d49173a3e292c9f926ad85c0e169f3562279f89c1447d"
    sha256 arm64_linux:       "82f632120fc0cb3bf80b34b626d4f4db67bc000d6cbfb0d48b65bc0ac2438161"
    sha256 x86_64_linux:      "5258cae7e8fd923cbb98311889c9de1ac3287dc49e4c9a23aae515499b113540"
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "mdds" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Upstream bug report for release 0.6.8 download asset
  # https://bitbucket.org/tagoh/liblangtag/issues/20/404-for-liblangtag-068tarbz2-asset
  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.6.7.tar.bz2"
    sha256 "5ed6bcd4ae3f3c05c912e62f216cd1a44123846147f729a49fb5668da51e030e"
  end

  deny_network_access!

  def install
    resource("liblangtag").stage do
      system "./configure", "--disable-modules", "--disable-silent-rules", *std_configure_args(prefix: libexec)
      system "make"
      system "make", "install"
    end

    # The mdds pkg-config .pc file includes the API version in its name (ex. mdds-2.0.pc).
    # We extract this from the filename programmatically and store it in mdds_api_version.
    mdds_pc_file = (Formula["mdds"].share/"pkgconfig").glob("mdds-*.pc").first.to_s
    mdds_api_version = File.basename(mdds_pc_file, File.extname(mdds_pc_file)).split("-")[1]

    # Needs concepts
    ENV.append "CXXFLAGS", "-std=gnu++20"

    ENV["LANGTAG_CFLAGS"] = "-I#{libexec}/include"
    ENV["LANGTAG_LIBS"] = "-L#{libexec}/lib -llangtag -lxml2"
    system "./configure", "--without-docs",
                          "--disable-silent-rules",
                          "--disable-static",
                          "--disable-werror",
                          "--disable-tests",
                          "--with-mdds=#{mdds_api_version}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libetonyek/EtonyekDocument.h>
      int main() {
        return libetonyek::EtonyekDocument::RESULT_OK;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
                    "-I#{formula_opt_include("librevenge")}/librevenge-0.0",
                    "-I#{include}/libetonyek-0.1",
                    "-L#{formula_opt_lib("librevenge")}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-letonyek-0.1"
    system "./test"
  end
end
