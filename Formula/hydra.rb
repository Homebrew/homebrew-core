class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v8.8.tar.gz"
  sha256 "bc895a7aebdf0279186d40140f0dc1546ac6f3a5c5bc9d13b13766bffea3e966"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "53a99c685662301197e3fc43696f7da59b408947055a94786874e413546a3c81" => :mojave
    sha256 "d49e7d0dd322ece528244fa888edc4f98e945e8b88a6c30f2f70b449e0d637b1" => :high_sierra
    sha256 "bae23f8f760bc421dbc27877a2433f69189d17cce3a9153d74de3140a4d8ee5f" => :sierra
    sha256 "ebeb58bc9aaf69d80552337c6f8adbe923390a8cc1d694dbef51c0a9d42699a6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "mysql-client"
  depends_on "openssl"
  depends_on "gtk+" => :optional
  depends_on "libssh" => :optional

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl"].opt_include
      # Avoid opportunistic linking of subversion
      s.gsub! "libsvn", "oh_no_you_dont"
      # Avoid opportunistic linking of libssh
      s.gsub! "libssh", "certainly_not" if build.without? "libssh"
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
