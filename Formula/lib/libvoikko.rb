class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.3.tar.gz"
  sha256 "d1162965c61de44f72162fd87ec1394bd4f90f87bc8152d13fe4ae692fdc73fa"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "5e7950f8b97300217f3ff6e9d8fa7a39f778f91fbb094e6a1106c155012ffe35"
    sha256               arm64_sequoia: "5618bf21692759e6d99d69328f3f0e7035e6efc7a4c11d859b5773f1ee198cb3"
    sha256               arm64_sonoma:  "319abe25e1227db8601a1ba59193e486341c5bfb056a44da5852ffa325ac93dc"
    sha256               arm64_ventura: "696e90c6f8e41b0a6fef11d7866014f9788bcae267e7d06022a8a61b71cab86c"
    sha256 cellar: :any, sonoma:        "1e6b95aadf093c5f52b77ffcf352fbfd64b462038b416354cda56f4b96403e94"
    sha256 cellar: :any, ventura:       "ec5e2e1976c7dfd2fc89331f972d032f1026db0e3ef668f987616794e3165a34"
    sha256               arm64_linux:   "4dcadd2f02546ee0864e8381f043f7f6369447b9239a8337d71d6728f731cd5d"
    sha256               x86_64_linux:  "3e8b94f4739855622459da189323479bcb0fa44a715c6fdf7decf46a67e49553"
  end

  depends_on "foma" => :build
  depends_on "pkgconf" => :build
  depends_on "hfstospell"

  uses_from_macos "python" => :build

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.5.tar.gz"
    sha256 "3bc9b0a0562526173957bf23b5caaf57b60ecc53be63fc16874118002ec620f1"

    livecheck do
      url "https://www.puimula.org/voikko-sources/voikko-fi/"
      regex(/href=.*?voikko-fi[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko",
                          *std_configure_args
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
