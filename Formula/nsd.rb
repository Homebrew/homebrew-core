class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.2.2.tar.gz"
  sha256 "83b333940a25fe6d453bcac6ea39edfa244612a879117c4a624c97eb250246fb"
  revision 1

  bottle do
    sha256 "70d66d7396db21ace3541a6be4b556b9f339570e71fa817941df594c1205686a" => :mojave
    sha256 "9fbd67d1d673c34b06f0f597e45b02121e98d286733e9df1d553daf8292b9b25" => :high_sierra
    sha256 "9391533efaae88803ac27fc7f450523d7a40ab02b4da422e15f8c6bb925cc6cb" => :sierra
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
