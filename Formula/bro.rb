class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.tar.gz"
  sha256 "1502a290d3663fa67a44ff6c1c8e8e9434b8ae5e76be5c2a02b06a0e391dc080"
  head "https://github.com/bro/bro.git"

  bottle do
    rebuild 1
    sha256 "8a397f3731a1c7abf4126235705b82381cb55b4a70b2e354f96f00b214a5ef83" => :sierra
    sha256 "a48cb079b41fe45aad9e4acf3f9d6ef774569cfa14b970a9e205c40882147848" => :el_capitan
    sha256 "fb0a8b536d58745f837a3e5731e6c34c09dd4542ca33c523860c3c9aea6dea84" => :yosemite
    sha256 "e0aab7ebf5af8aea92fadc1df19f2ad6d65a2a1a91f62ecd4a2c2146466b989c" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

  conflicts_with "brotli", :because => "Both install a `bro` binary"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
