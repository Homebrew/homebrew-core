class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.12.tar.xz"
  sha256 "b9fa82fbeb8cb7a701101060e4f3e1e4ef7c38f574b2859d3ecbe43604c21f83"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_sequoia: "0eb492997db6e7df366f6be4b4c30778aed163f97279c114325d3c1caf551032"
    sha256               arm64_sonoma:  "5b0326bceb378ae5864f2be1b20d835e8f033cef7e0a12fc08e21a9bc1010161"
    sha256               arm64_ventura: "18b9e602c028f0c0c77b366ac2509f74bc2243f557b20c510952b389b512ca95"
    sha256 cellar: :any, sonoma:        "5976299ba865549520b864036093f709d7fa18fd06fb46de1a8773ee0da058b5"
    sha256 cellar: :any, ventura:       "b40d8148bec5f1360852a4e4a943e7d2e28b1ec95c747cc0d4516a438e8a1218"
    sha256               arm64_linux:   "4a1dd9920ae1ce725bbca2fd65d867f5461e137173d33846616f1151c4e95fd5"
    sha256               x86_64_linux:  "88cd3008e344d4ebf311a8035ef6b0108e9811046c43c4480831df4c169b66dc"
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "mdds" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.6.7.tar.bz2"
    sha256 "5ed6bcd4ae3f3c05c912e62f216cd1a44123846147f729a49fb5668da51e030e"
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
