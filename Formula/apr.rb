class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.6.2.tar.bz2"
  sha256 "09109cea377bab0028bba19a92b5b0e89603df9eab05c0f7dbd4dd83d48dcebd"

  bottle do
    cellar :any
    sha256 "b5b531052200cb05e72d836b24c589785d36606be257928b47dbe898e2712b95" => :sierra
    sha256 "4844340e4ee02770997461fbc82b9cd038d364c1335f4f1312f1a01bab2f8d5b" => :el_capitan
    sha256 "3f22982c60f9673fbe9d13203dc3e5540353ab5c64b2ce9ae671c65b4a928fb1" => :yosemite
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
