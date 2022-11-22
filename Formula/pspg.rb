class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.12.tar.gz"
  sha256 "8cee0a0cd4aa8a5ce91c11b1d6cb34b87deb71a78a6b25a6993f1af2264957c3"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dad5957c20e6d2fa172de78f8a17ed68a96344333e871302bc20b366882f6ef1"
    sha256 cellar: :any,                 arm64_monterey: "03539b714f5c6855e9f56eca72a06e967eca97c19a26f3f89b15d008a76a2cc9"
    sha256 cellar: :any,                 arm64_big_sur:  "1965c707b8b8466dba4b9df7ba543fdfb2699fc5020fc5b6be5d3fb12416b54d"
    sha256 cellar: :any,                 ventura:        "efdfb6fa9006e85322ade93db0a7b9e664be5212080e6292c926cca88fa6e9d9"
    sha256 cellar: :any,                 monterey:       "c36ebec9b72a04a5392ab59082b0de959d20222c9a692b096299c91aecf63db5"
    sha256 cellar: :any,                 big_sur:        "af2df65f4259244fe51f30e2d0682a7bafb9e6f5548f7ee295a516ba2fa01d75"
    sha256 cellar: :any,                 catalina:       "09df456842b33c0ecd8123c639393bec1c1d4936a08df505793b7ea9af6af452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42b80cd796e846c9eea63dba54ec568def4e7fea4c1c41cd8febd4e1074c2b3"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
