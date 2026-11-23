class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.14.tar.xz"
  sha256 "11b33496db3f36af0456086229d154e6d0e64f27bff96112e1036da1db38d631"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "a2660c8e503a32eb17d99c22e52cfb9faca726bfc3c9e4d95f917a0018802bc4"
    sha256 arm64_golden_gate: "215ad88b396a516af14ac1a867bd11338d56372c0a7e89cf0e41c00cc145a66f"
    sha256 arm64_tahoe:       "0f7f4c8697a67cc68d956138330739534b26699781c4e60ee79a169c9999527b"
    sha256 arm64_sequoia:     "62da39ac496d37a5e77e8a39076a8bc95521f1a65e309903a7ab7aabbd35dd31"
    sha256 arm64_linux:       "e6813a0c146f1138e434bb4df2f338787e008cd2adbff574995fb37b1e32ffec"
    sha256 x86_64_linux:      "f595d776b8a737b91d605cf823ba606f31ac9cbdcab1d7102b1e06e3a846e1da"
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
