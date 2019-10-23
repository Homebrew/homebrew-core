class Libbiosig < Formula
  desc "Biosig library"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig4c%2B%2B-1.9.5.src.tar.gz"
  sha256 "20e72a5a07d1bf8baa649efe437b4d3ed99944f0e4dfc1fbe23bfbe4d9749ed5"

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "gnu-tar" => :build
  depends_on "pkg-config" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"
  depends_on "tinyxml" # if version == "1.9.5"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install_headers"
    system "make", "install_libbiosig"
  end

  test do
    # prepare for linuxbrew
    # ext = { true => "dylib", false => "so" }
    system "ls", "/usr/local/lib/libbiosig.dylib" # + ext[OS.mac?]
  end
end
