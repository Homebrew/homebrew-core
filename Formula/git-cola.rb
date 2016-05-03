class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.6.tar.gz"
  sha256 "ed566548793b4905005528d5e612c41bea5b5f7602649c0eec0787fbb0ab9cd2"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a70f7c02f221064cbdcd584a7e71c5687506ed4471f91de5f2a6470f1539e8bd" => :el_capitan
    sha256 "5e81e8cd514bddb4c67e45ce28b28e9cf0c7e3dc55dac4168c93df282428e858" => :yosemite
    sha256 "50b4ec00f06fb345284f2499816ad00ed3276c36645705df93b950fe4719991d" => :mavericks
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    system "make", "prefix=#{prefix}", "install"

    if build.with? "docs"
      system "make", "install-doc", "prefix=#{prefix}",
             "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
