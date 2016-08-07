class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "http://lav.yar.ru/download/le/le-1.16.3.tar.xz"
  sha256 "0be61306efd1e6b511c86d35c128e482e277e626ad949a56cb295489ef65d7b9"

  bottle do
    sha256 "d63b77a681d74c2c97314fac32c93c4881c66b3c4e05ec2e207838ddda45ac90" => :el_capitan
    sha256 "895ac3308015381bbc23de9000df04c60f030eba9893fc2a5d036ff7d2c91355" => :yosemite
    sha256 "4118ed76a761d851a05a2886da41a984175ad25938ab0e91f878d405fbc19618" => :mavericks
    sha256 "696ba6e3163b72f35825f7f17b1c11cacf044efda4b6fbf14324f7c5688178d1" => :mountain_lion
  end

  conflicts_with "logentries", :because => "both install a le binary"

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
