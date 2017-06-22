class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.5.2.tar.bz2"
  sha256 "7d03ed29c22a7152be45b8e50431063736df9e1daa1ddf93f6a547ba7a28f67a"
  revision 3

  bottle do
    cellar :any
    sha256 "7421ebf15011c00fff76530a40fe78aca7ddec4d1c6dbf2327bc13ea22dbc361" => :sierra
    sha256 "63628dded3e37b9768b32ca65837ef0c1adcd0aa6d065c5604315cfa6069ceda" => :el_capitan
    sha256 "1364ce1a6a2786b9b6fcb10a2df966678383a650d99b369ee2cd811ded4afd57" => :yosemite
    sha256 "a4e7a90d12fac10ac788be3472c3e77a12e2db1a889d7be45f521d8387df28a0" => :mavericks
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr"

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apr-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apr-1-config --prefix")
  end
end
