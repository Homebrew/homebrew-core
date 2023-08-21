class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.2.tar.gz"
  sha256 "0156c2aaaa32d4b828addc7cefecfcea4591828a0b40f0cd8a80cd22f8590da2"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7a92f298b4e10b01505b6933f61bc858f0bc0713c825194802a8eae652dad20"
    sha256 cellar: :any,                 arm64_monterey: "a838e8ec04c3643544b3b832b31c8f62dddff8135f15c86548f07c1dcb78ebb3"
    sha256 cellar: :any,                 arm64_big_sur:  "1aad5d6a19c008bac0ded55478ade1f5b1535a29b7f4eb1130c5a1ca61c06946"
    sha256 cellar: :any,                 ventura:        "9f0e09cb95209e847f281cbfcaec7375637a726c36df6ff2d29d9954225b8846"
    sha256 cellar: :any,                 monterey:       "121c5c56e2d25d74e01d3d9ae1d3ddc885dcf1336fabf9b75bfa4f191e8bd9b7"
    sha256 cellar: :any,                 big_sur:        "8b613d992e6e2d7311447d13a07b02a9c8ac42f60634c60c4be798b2fd872b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3867449e1d923fd8c032734cf0e211f8b02e2afaa7e8d20797e4d700d2291931"
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.5.tar.gz"
    sha256 "3bc9b0a0562526173957bf23b5caaf57b60ecc53be63fc16874118002ec620f1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    assert_match "C: onkohan", pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
