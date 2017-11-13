class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  revision 1

  stable do
    url "http://files.itstool.org/itstool/itstool-2.0.4.tar.bz2"
    sha256 "97c208b51da33e0b553e830b92655f8deb9132f8fbe9a646771f95c33226eb60"

    # Upstream commit from 25 Oct 2017 "Be more careful about libxml2 memory management"
    # See https://github.com/itstool/itstool/issues/17
    patch do
      url "https://github.com/itstool/itstool/commit/9b84c00.patch?full_index=1"
      sha256 "c33f44affc27604c6a91a8ae2e992273bf588c228e635ea46d958e2c3046e9ca"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4d9aec732db3d58433a777f5922a5f24e963e8875f7cc1cb9f7781573d5277ea" => :high_sierra
    sha256 "4d9aec732db3d58433a777f5922a5f24e963e8875f7cc1cb9f7781573d5277ea" => :sierra
    sha256 "4d9aec732db3d58433a777f5922a5f24e963e8875f7cc1cb9f7781573d5277ea" => :el_capitan
  end

  head do
    url "https://github.com/itstool/itstool.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libxml2"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <tag>Homebrew</tag>
    EOS
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
