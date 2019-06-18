class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.0.tar.gz"
  sha256 "56672e253c128abaa6fb19e77f6f59ba6a93762a9ba435505a009ef6d58e8d0e"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "7c5982a29e085723482af4e20852f243542f83d8b4f7c2f697c5522442a8e9d9" => :mojave
    sha256 "bb88b58e028a3b2498da0eaae5fa1030cce8103336fc90ce813ebdd7a77f933f" => :high_sierra
    sha256 "e2cf5b672b4f6328ce24264e5f0f17c5d78de9711878bc0bc9e1d1fe34efd916" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl"

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl"].opt_include
      # Avoid opportunistic linking of subversion
      s.gsub! "libsvn", "oh_no_you_dont"
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hydra", 255)
  end
end
