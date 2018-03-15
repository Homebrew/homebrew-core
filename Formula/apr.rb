class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.6.3.tar.bz2"
  sha256 "131f06d16d7aabd097fa992a33eec2b6af3962f93e6d570a9bd4d85e95993172"

  bottle do
    cellar :any
    sha256 "df09dd9ba91dc0db6a6f5ac8d97b82203d5930af14494a790860b9cf3635c0a4" => :high_sierra
    sha256 "2e3d88d6204b023756dd52d70385dcbd405bdc91295b023b7d04e1bfe1f95ccf" => :sierra
    sha256 "16cdb68cf34cc80919c8689c64310313b04a181c6a57901440398d19a668dd38" => :el_capitan
  end

  keg_only :provided_by_macos, "Apple's CLT package contains apr"

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    rm Dir[libexec/"lib/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apr-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apr-1-config --prefix")
  end
end
