class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.10.tar.xz"
  sha256 "b430435a6e8487888b761dc848b7981626eb814884963ffe25eb26a139301e9a"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256               arm64_sequoia:  "647ec0cd1b38385cb21e641f287b3c241dded4492aac47dc4bf531e295523258"
    sha256               arm64_sonoma:   "277d4979dc6ed3a41dffd32885df1731ac00920ff217b0f97f0b96a5e2471d2b"
    sha256               arm64_ventura:  "7d0639b6a0326628a58a188d117e363b110ffb4f738f273add9b402425db5e07"
    sha256               arm64_monterey: "f3209b23826845190ee6d095526f88f18c7c9c488d7421f7e431884f4b8a586e"
    sha256 cellar: :any, sonoma:         "7b4264fdb34b6f548cb348e500c218353ff12f301f43b6c4584011b9b99ce7b9"
    sha256 cellar: :any, ventura:        "40ff13c4db031f9ff7fd33fa4153a46c8832301174c244b269d6ff1e3d4ab041"
    sha256 cellar: :any, monterey:       "c118d347c1829578898e918bf41b1f84d23210933e0f3bbd4acb56392bba37c1"
    sha256               x86_64_linux:   "d7b04fd7fdc5a6fc7b7cd8bba18aa1f48e4d418166ecaf36a6174b62149655f6"
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "mdds" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

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
    # Work around upstream boost issue, see https://github.com/boostorg/phoenix/issues/115
    # TODO: Try to remove after boost>=1.84
    ENV.append "CXXFLAGS", "-DBOOST_PHOENIX_STL_TUPLE_H_"

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
    (testpath/"test.cpp").write <<~EOS
      #include <libetonyek/EtonyekDocument.h>
      int main() {
        return libetonyek::EtonyekDocument::RESULT_OK;
      }
    EOS
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
