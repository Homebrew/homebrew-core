class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.19.tar.bz2"
  sha256 "f9c27b1883914a1b1d4965f4c49b2be502e2a9fc9dd3f61123abeae989c354bc"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc395b12e05e924850d9c3140e2df688645dbd3cb6fbe0ee55a85efecfc3a25d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b6a8ec1dbee03ec73761e62abdb29e25daf9a5f5cd2339281784e73e35b27f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "604a45cdc202a4cb1ee084a350b8ad989f135e29d1d4153a9c9e20818da8e31e"
    sha256 cellar: :any_skip_relocation, ventura:        "82beb4fa65191d059c74f556d92b2c2250f676a60fe9ca69fea353b40cc14ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "a4c13e32789f3e2dc6e8c1c41d7a680e5fad4464ed59cddda4b859de3d669573"
    sha256 cellar: :any_skip_relocation, big_sur:        "bce4e87b0f16217d84a01e664c6e96c530d561da301912bfd9e39ec7ff584a74"
    sha256 cellar: :any_skip_relocation, catalina:       "95487d963289a6fbc97a933a492a8f82ae88ad7087ca525d710edea34e100f0a"
    sha256 cellar: :any_skip_relocation, mojave:         "06193d389cb3f1ba85f07fda25e0f17ac732efd289597a6ea2e6ce440123bb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ef9a31b1b7ad620a2a4166df38aed63399796ebf40e52ba6e52172c49463798"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end
