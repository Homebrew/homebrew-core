class Lha < Formula
  desc "Utility for creating and opening lzh archives"
  homepage "https://lha.osdn.jp"
  url "http://dl.osdn.jp/lha/22231/lha-1.14i-ac20050924p1.tar.gz"
  version "1.14i-ac20050924p1"
  sha256 "b5261e9f98538816aa9e64791f23cb83f1632ecda61f02e54b6749e9ca5e9ee4"

  bottle do
    cellar :any_skip_relocation
    sha256 "450fa8188af44eef619302c402860dfd2debab864487424211fbbfa7ff065955" => :sierra
    sha256 "35f3e193c1bf0d26c62ea6897721c559191fea64f27d71781a90f670d9a23557" => :el_capitan
    sha256 "9cb516a73d1d117c39f63d16b3211df626783c9bb1a7038f524dd9c36045b1ac" => :yosemite
    sha256 "bd26a5a48396d06019f7998f4c9bf511a74ef237814fee5f5c8ba9df31b30a37" => :mavericks
    sha256 "3def5e7035ef758428c7e158b93ad5459d6d221ba4698608cc1d14526cbfd5f8" => :mountain_lion
  end

  conflicts_with "lhasa", :because => "both install a `lha` binary"

  head do
    url "http://scm.osdn.jp/gitroot/lha/lha.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-is" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/lha", "c", "foo.lzh", "foo"
    assert_equal "::::::::\nfoo\n::::::::\ntest",
      shell_output("#{bin}/lha p foo.lzh")
  end
end
