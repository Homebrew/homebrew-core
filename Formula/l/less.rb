class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-691.tar.gz"
  sha256 "88b480eda1bb4f92009f7968b23189eaf1329211f5a3515869e133d286154d25"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c23ae5763bcba9cbff2da7967fec51fd3f51e36b0522558ccbebd7b8bd17341"
    sha256 cellar: :any,                 arm64_sequoia: "6c85b28bcb617f101c830b3cec3f98eabe0de4e151a5fbdf37f70b3b38ea5983"
    sha256 cellar: :any,                 arm64_sonoma:  "f9c731b3ac564cbf7f1c7cdfa65ba71026baac38816648932c2c433901171000"
    sha256 cellar: :any,                 sonoma:        "e816da7f3c8ba12c261895ef68afab4fb84dbb57c6f66c1d9763395cad289668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc1dcbbb63e319f1a4d7d2ec493b42fceebb7345df3cbdc1640bae1bbfc88242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d928500f063a44e6bf7a27c3b154dfbacefb4ee73ba080a687f452cf2204ec2f"
  end

  head do
    url "https://github.com/gwsw/less.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "groff" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system bin/"lesskey", "-V"
  end
end
