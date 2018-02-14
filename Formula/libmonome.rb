class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.1.tar.gz"
  sha256 "a79af7e22f835f2414f12503981d6a40527e0d006a03fd85aec59a6029ffc06c"
  head "https://github.com/monome/libmonome.git"

  bottle do
    sha256 "5e8452d3349ea98e6d8a72cdcf2bdfd4224c1d07a421823217f825e92c655933" => :high_sierra
    sha256 "1d91d19c2c14b1c03e08d3ffe9b71e570a0751057a6201ef5ba6e56bab6ab9b9" => :sierra
    sha256 "a44ad5902f185e66d50f9f7aace7073964e8fe9d2c912fa036e14dd24fd8486c" => :el_capitan
  end

  depends_on "liblo"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
