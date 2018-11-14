class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.6.2.tar.gz"
  sha256 "2b824ae7b8b7b51857c528aa16192f09c0fa679141d2bbc7f55b9a90c6098894"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "86225f4976bcc4790a4b9b767b4f09f6c8733a5fec0a52d40066598d9bf2f871" => :mojave
    sha256 "8be10acb89d747174241eeed867676f9da2fdf026bb756e95c7acc119d1d3eb3" => :high_sierra
    sha256 "a304c8e75d3133ce14686468930621ca466347b307187e9e1af6e66ef6701bda" => :sierra
  end

  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
  EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
