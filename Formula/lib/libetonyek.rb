class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.13.tar.xz"
  sha256 "032b71cb597edd92a0b270b916188281bc35be55296b263f6817b29adbcb1709"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "6d771bb8fe17a85d3b2a9002386e939430093dc183994fdec8099557e7a720ee"
    sha256               arm64_sequoia: "7d189eec7883d3a155b1af40d0fa62d9a7c811880a6c111e9c44f607d09abc01"
    sha256               arm64_sonoma:  "bed128b541a6bdb57fc33c0b768b5687a2fc49530ce55ed79504e06ff41f7eb8"
    sha256 cellar: :any, sonoma:        "b441be21fc635de2cc808402d8922eb7eaefd48a11851774a078468c6f12fbc9"
    sha256               arm64_linux:   "e01a1def146c1dc1e3394df6753fea3275b0f5a2854122f09cb861b2c2f0d8d0"
    sha256               x86_64_linux:  "73ae1b87ec6ca1b4e3cf3688956975ba37fa3ec44c28ba184ee51f311167a6ec"
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "mdds" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Upstream bug report for release 0.6.8 download asset
  # https://bitbucket.org/tagoh/liblangtag/issues/20/404-for-liblangtag-068tarbz2-asset
  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.6.7.tar.bz2"
    sha256 "5ed6bcd4ae3f3c05c912e62f216cd1a44123846147f729a49fb5668da51e030e"
  end

  # Apply Fedora patch to fix build with mdds >= 3
  patch :p0 do
    url "https://src.fedoraproject.org/rpms/libetonyek/raw/65a93fb7f21fb0e668d78644ec6aa7843e5372f5/f/mdds3.patch"
    sha256 "cd390fa4280b78fd0d1a7f587ab576d8ef0c4848036c8b0c821b576c6745db17"
  end

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

    # Override -std=gnu++11 as mdds>=2.1.1 needs C++17 std::bool_constant
    ENV.append "CXXFLAGS", "-std=gnu++17"

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libetonyek-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-letonyek-0.1"
    system "./test"
  end
end
