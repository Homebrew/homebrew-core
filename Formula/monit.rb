class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.26.0.tar.gz"
  sha256 "87fc4568a3af9a2be89040efb169e3a2e47b262f99e78d5ddde99dd89f02f3c2"
  revision 1

  bottle do
    cellar :any
    sha256 "b67b8d266fbd7ca156a98932a8b5445ad740ee7217d6c8fdc43ca82fcce79a59" => :mojave
    sha256 "d3a45d4d8ad336fe6e4ad9b0c45ebb6eda76977bc71cfaa755a481c837ab6cf3" => :high_sierra
    sha256 "a4ec2fe5a66764c4135ad8332206a9f4eedf384f0f48aa8bccf8bbe4ec5713c7" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
