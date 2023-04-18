class Chordii < Formula
  desc "Text file to music sheet converter"
  homepage "https://www.vromans.org/johan/projects/Chordii/"
  url "https://downloads.sourceforge.net/project/chordii/chordii/4.5/chordii-4.5.3b.tar.gz"
  sha256 "edb19be9de456366e592a75a5ce1c0a75352a55d5b4e5f282c953c7e7f2d87b5"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/chordii[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a978e9a6f9374a3129e063dbc1c530c3d783a59ace97773a42c25e9046d0608"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3296c96f2502beef0d8730a8fe434f997b831737cfa352d8882b59303becc16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "048b6fde3228875e2f6e9267c71eb6228b3b0382ce638f9b2e29199ec3cf7aa2"
    sha256 cellar: :any_skip_relocation, ventura:        "533776ba55d08f2e8f35a1efe53ba52e97e1d360029f97dfb10dedc5c7920857"
    sha256 cellar: :any_skip_relocation, monterey:       "2b6187af85a480a5e77c8b39a539b6ecd2e2be2f66314088a97a83024f8bb584"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c6ea34e2f65484ebc2d74c2f658f09ef78e2893bb6ee7f7674f1c72f8d8f98"
    sha256 cellar: :any_skip_relocation, catalina:       "ed1f635a737973af4b9f4f784757cdf0ddbb3f946cb285917c171392a9b59d4a"
    sha256 cellar: :any_skip_relocation, mojave:         "def6b665fba55dfb8fa30269966e059b0a827f62a2338f73ea89c47a42fa7de7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1901080a06bb4728ec9858e4e548f68e044534b9d65dee1996f0590b56abc1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc33f2a8fd3dda76dc87a7a919c7e590a4853a0736bc92c20d25e0d8382db6d"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.cho").write <<~EOS
      {title:Homebrew}
      {subtitle:I can't write lyrics. Send help}

      [C]Thank [G]You [F]Everyone,
      [C]We couldn't maintain [F]Homebrew without you,
      [G]Here's an appreciative song from us to [C]you.
    EOS

    system bin/"chordii", "--output=#{testpath}/homebrew.ps", "homebrew.cho"
    assert_predicate testpath/"homebrew.ps", :exist?
  end
end
