class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "https://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.10.tar.xz"
  sha256 "b430435a6e8487888b761dc848b7981626eb814884963ffe25eb26a139301e9a"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libetonyek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "991a176efa7b7ba0e53080b6e038ae7e50cf0703be1ed9a827461d2ce8ee58c0"
    sha256 cellar: :any, arm64_monterey: "823ff94f1331fb0f24e356c2326d27ea8b71cd12aeea2cbbea26cf953a86f95a"
    sha256               arm64_big_sur:  "8ca7825177d98f44ac9f3d6ad409eb3bc79d4621cb6c75aea43f60ca66234d0f"
    sha256               ventura:        "95f096d9d12ac831defe8fa2e43a9189569b0782d8cebb8cc12d5faf2e495930"
    sha256               monterey:       "b402d2d2b2e6e885b0ee19d55d43adb5b8e7e2af5d0b913f5bbc05456f493b1c"
    sha256 cellar: :any, big_sur:        "c0d419840c9454c6fe46fcffe7e27d57a8a5ea6a26a9bdd75ab6756f9399b2d0"
    sha256 cellar: :any, catalina:       "d40376bdfb4527e035ec8c0c1d65927303f81a456d02ce9fb0503a41f5e9ee60"
    sha256 cellar: :any, mojave:         "1d30b4258651cc6edbd2e7e39d6af095a25f52994baa3ed34e2be0e2f606ecf2"
    sha256               x86_64_linux:   "50c4ec0dd235b3cde8180781e8392183d8b2f7e932f571a4317e0437deec01cd"
  end

  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "mdds" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

  resource "liblangtag" do
    url "https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-0.6.4.tar.bz2"
    sha256 "5701062c17d3e73ddaa49956cbfa5d47d2f8221988dec561c0af2118c1c8a564"
  end

  def install
    resource("liblangtag").stage do
      system "./configure", "--prefix=#{libexec}", "--enable-modules=no"
      system "make"
      system "make", "install"
    end

    # The mdds pkg-config .pc file includes the API version in its name (ex. mdds-2.0.pc).
    # We extract this from the filename programmatically and store it in mdds_api_version.
    mdds_pc_file = (Formula["mdds"].share/"pkgconfig").glob("mdds-*.pc").first.to_s
    mdds_api_version = File.basename(mdds_pc_file, File.extname(mdds_pc_file)).split("-")[1]

    ENV["LANGTAG_CFLAGS"] = "-I#{libexec}/include"
    ENV["LANGTAG_LIBS"] = "-L#{libexec}/lib -llangtag -lxml2"
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}",
                          "--with-mdds=#{mdds_api_version}"
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
