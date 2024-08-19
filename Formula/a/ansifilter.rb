class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://andre-simon.de/doku/ansifilter/en/ansifilter.php"
  url "http://andre-simon.de/zip/ansifilter-2.20.tar.bz2"
  sha256 "35ec9d71a7f4e5601337937c7734b32a6e346c0f054f4d316376823cfe679067"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cf9ccadc1d0aa31696d7455a1855ec19629192825cd573796103e5775ee76aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99c03b9d91a8df245d7e35173068bb82ad1791b6e94ff0a598261218b449be06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e7516c49bc36f2e50bbef6b0048ca045fbf1c44d81ac30dd9928e1d4760bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29440dc9ad145465cd96401712501adc03e0ff43edcf8b86a1dc330b335f94b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7c799fe7a76f7227b26af082b26f87951fbb0fb6c8ee69e675183d65e9cce02"
    sha256 cellar: :any_skip_relocation, ventura:        "121ae4e270a9a3c845404c2aea06f736f2f6a3fb96cb2b9d4961142039f6ea03"
    sha256 cellar: :any_skip_relocation, monterey:       "b7813ee4d579827f53e7853a54acde239b1ab29478699b292b8b5862bb5d13df"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa9881fef27218402726e95b0128aaeede6f47f78fdc5806577de90081cbf9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f621d1e0aebb309bf2afccbec0d347c64e8ac976f15fe2b9a0cda6f3b737d93"
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
