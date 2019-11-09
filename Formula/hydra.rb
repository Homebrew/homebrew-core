class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.0.tar.gz"
  sha256 "56672e253c128abaa6fb19e77f6f59ba6a93762a9ba435505a009ef6d58e8d0e"
  revision 4
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "349f0dc6653ffbd73979c142a0c409a1a5eb226cc670922eded4a184311fe0bb" => :catalina
    sha256 "1c3e624176225d39a30f4527f715c1f5e8c703495b87d69fc4d50f3f3fca8d44" => :mojave
    sha256 "3d5e99635237d29089f6c73f94a383ac55d73ca13bccd36bd40a04bc881ba105" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl@1.1"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl@1.1"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl@1.1"].opt_include
      # Avoid opportunistic linking of everything
      %w[
        gtk+-2.0
        libfreerdp2
        libgcrypt
        libidn
        libmemcached
        libmongoc
        libpq
        libsvn
      ].each do |lib|
        s.gsub! lib, "oh_no_you_dont"
      end
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
