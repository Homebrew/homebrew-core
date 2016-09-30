class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "http://mldonkey.sourceforge.net/Main_Page"
  revision 1

  head "https://github.com/ygrek/mldonkey.git", :branch => "next"

  stable do
    url "https://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.5/mldonkey-3.1.5.tar.bz2"
    sha256 "74f9d4bcc72356aa28d0812767ef5b9daa03efc5d1ddabf56447dc04969911cb"

    # upstream commit "fix build with OCaml 4.02 (closes #6)"
    patch do
      url "https://github.com/ygrek/mldonkey/commit/c91a788.patch"
      sha256 "1fb503d37eed92390eb891878a9e6d69b778bd2f1d40b9845d18aa3002f3d739"
    end

    # upstream commit "Fix compilation errors with gcc5"
    patch do
      url "https://github.com/ygrek/mldonkey/commit/cca5f2d.patch"
      sha256 "967494dba64a1b977ffa90d41366ed60d08dac29218ae92ea926f5a8656b5548"
    end

    # upstream commit "Fix compilation with OCaml 4.03.0"
    patch do
      url "https://github.com/ygrek/mldonkey/commit/781256f.patch"
      sha256 "61bb320a0e0b517645e4bba3429d1fc544c5ea2aad8be701b05b3354f14356d8"
    end

    # upstream commit "another fixes [sic] for 4.03"
    patch do
      url "https://github.com/ygrek/mldonkey/commit/f8d595d.patch"
      sha256 "70dab4bcba59560820263f16095ee9f7025b2f2e183275b25355ed820820789b"
    end
  end

  bottle do
    sha256 "be4ea8383b99d4ab1d7ffa47279704cff3fe9e9549fcb9b9bb05643819cc866f" => :sierra
    sha256 "d6ec1942b514679463a5076ed0a0cdc6e966b0561c08d349a72d5306e71a2e6b" => :el_capitan
    sha256 "3026f405909a52a923fe38e81690dcbe44efa8daa36d15af84d4be410ac451bc" => :yosemite
    sha256 "0d11e1995f0e83158017201f92ac787f59e336e70f444c78cb839fa0cd3e0ce4" => :mavericks
  end

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libpng"

  def install
    ENV.j1

    # Fix compiler selection
    ENV["OCAMLC"] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mlbt", "--help"
  end
end
