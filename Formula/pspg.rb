class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.0.1.tar.gz"
  sha256 "9dc539b4acde5a11adc90a2017dd9a26fd32636fc1109c49dfdf4283e224144b"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "4bac312005358d7f6c4ffe865444b477a46c6eac7edf203ef5715a314caca323" => :mojave
    sha256 "b33b87d7e4f7ac75396572d7c44408ae935e4202a9d9923b33844dc05f179623" => :high_sierra
    sha256 "5638bacf37bbafa5a967d7b092399ebc6e863dcd380e0414b254e130e364366d" => :sierra
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
