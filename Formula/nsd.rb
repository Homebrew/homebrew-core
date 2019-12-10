class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.2.4.tar.gz"
  sha256 "9ebd6d766765631a56c0eb332eac26b310fa39f662e5582c8210488cf91ef27c"

  bottle do
    sha256 "605b512b4385024dc63faf79f921fb62e0dfe318e601a20c21356558cd4ea9fb" => :catalina
    sha256 "d28bbf5f89d55a2b82b58dc96fa92742164632258be0c2a26ac6634e9af4273d" => :mojave
    sha256 "51dc8e3215c18f56d04bb4c5eef68967fced2691fd30c152b7a574375103554d" => :high_sierra
  end

  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
