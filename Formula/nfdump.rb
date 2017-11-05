class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://nfdump.sourceforge.io"
  url "https://github.com/phaag/nfdump/archive/v1.6.16.tar.gz"
  sha256 "b18479215c51a98fbdf973ef548464780e7a9d9f7fe73e4fab9ab7ec8a3bdc8f"

  bottle do
    cellar :any
    sha256 "8d6bf64877ed6b75bb1cf07e58d3474aba7dba982e3cd5c76c5adf646f1e6782" => :high_sierra
    sha256 "a387e4ffa2c5da2aa4a44fe411fefc9434f888d7f8310e110d10c566f2e61160" => :sierra
    sha256 "8007ce2f9c414dc027fd156a3ef2b2023b16a8c51e3b76ee37a82cca3a96d769" => :el_capitan
  end

  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    # https://github.com/phaag/nfdump/issues/32
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"nfdump", "-Z 'host 8.8.8.8'"
  end
end
