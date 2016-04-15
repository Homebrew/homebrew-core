class Iodine < Formula
  desc "Tool for tunneling IPv4 data through a DNS server"
  homepage "http://code.kryo.se/iodine/"
  head "https://github.com/yarrick/iodine.git"

  stable do
    url "http://code.kryo.se/iodine/iodine-0.7.0.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iodine/iodine_0.7.0.orig.tar.gz"
    sha256 "ad2b40acf1421316ec15800dcde0f587ab31d7d6f891fa8b9967c4ded93c013e"

    depends_on :tuntap
  end

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "0eec156b89c9bc7b9f13e9865b4e119fe5c744dfe9d5f207e444f79b87bee214" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{sbin}/iodine", "-v"
  end
end
