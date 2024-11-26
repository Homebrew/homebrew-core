class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.11.tar.xz"
  sha256 "4bbce5aecbfc939e24a2c654efed561930c4605c270476df455fb3118b3ce3ce"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_sequoia: "33625e0fd425a1d316273c53d0fc0b78a4731d2181f4368c662a19f3c4d9d36e"
    sha256               arm64_sonoma:  "2aa916c2a2a69ddb9aee72cb2817b5403372d3bbbe6a0816a59f27c5a0c499fa"
    sha256               arm64_ventura: "1a6406249a29e3bd3aa3919dff1f293ddb3fb688e9c2486e4604b7838d12f2c2"
    sha256 cellar: :any, sonoma:        "3f12af26a6a0a2a921f63b645f8ee81637ac431e0870452644c3b70818c43570"
    sha256 cellar: :any, ventura:       "9149bd7f11e97a6f61896d5a9df299e93911d7767e6e251558d684d6cbe54097"
    sha256               x86_64_linux:  "4b6a13e931fc36ec5dc12cbd690632940e23663bdab180cbfb9f34977c79964e"
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
