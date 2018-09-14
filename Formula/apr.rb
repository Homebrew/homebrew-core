class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.6.5.tar.bz2"
  sha256 "a67ca9fcf9c4ff59bce7f428a323c8b5e18667fdea7b0ebad47d194371b0a105"

  bottle do
    cellar :any
    sha256 "0111bfb48f0a020292bd503c2c8e1b374f9ea844c3cc32a0b35a670234adc055" => :mojave
    sha256 "314c8ebd08304a0f7dcebe3ca7fe5cc6b1c283b744f12d19d0931b91fac4fe20" => :high_sierra
    sha256 "71cb98918a64daac38641bf4bbfb9457693ffd4109c023f0c3a50bfa029141f7" => :sierra
    sha256 "a3e0d0b44862e575f529d9b6fdf467b507dced4bfcf9afc30d06d3ddc5e51a0e" => :el_capitan
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
