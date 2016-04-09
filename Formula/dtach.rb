class Dtach < Formula
  desc "Emulates the detach feature of screen"
  homepage "http://dtach.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dtach/dtach/0.8/dtach-0.8.tar.gz"
  sha256 "16614ebddf8ab2811d3dc0e7f329c7de88929ac6a9632d4cb4aef7fe11b8f2a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "dadab3b4c573d323fe3bba6f00533209429648c24aff85a4ca9cd5a97c891c88" => :el_capitan
    sha256 "7543ba893449b3be18d23307edcdb54a30b7a9964c13194eb089af809c563408" => :yosemite
    sha256 "725973145d09ccba58459afc0624f25df1a54daf47e8099a1e5ec1fb9a1af916" => :mavericks
  end

  def install
    # Includes <config.h> instead of "config.h", so "." needs to be in the include path.
    ENV.append "CFLAGS", "-I."

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    bin.install "dtach"
    man1.install gzip("dtach.1")
  end
end
