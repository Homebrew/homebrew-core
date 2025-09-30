class Chordii < Formula
  desc "Text file to music sheet converter"
  homepage "https://www.vromans.org/johan/projects/Chordii/"
  url "https://downloads.sourceforge.net/project/chordii/chordii/4.5/chordii-4.5.3b.tar.gz"
  sha256 "edb19be9de456366e592a75a5ce1c0a75352a55d5b4e5f282c953c7e7f2d87b5"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/chordii/rss?path=/chordii"
    regex(%r{url=.*?/chordii[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d07735a1513b3c86ea5fa4db756e4c2238c7bb4ab60bfda160e56940c5abca28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d957516291bf50268bfc7a90bfb72ae62ae3e54e249a6156033f0938c9d4fbbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d68e6d5490b3ee5a4f07fc445faa9716fd72ce3fbf89285d9eceb2cfa2696dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a978e9a6f9374a3129e063dbc1c530c3d783a59ace97773a42c25e9046d0608"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3296c96f2502beef0d8730a8fe434f997b831737cfa352d8882b59303becc16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "048b6fde3228875e2f6e9267c71eb6228b3b0382ce638f9b2e29199ec3cf7aa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "108b4600c4d39a1ebffbe13cb9a0841a53cfff76de078409b8a213386611219e"
    sha256 cellar: :any_skip_relocation, ventura:        "533776ba55d08f2e8f35a1efe53ba52e97e1d360029f97dfb10dedc5c7920857"
    sha256 cellar: :any_skip_relocation, monterey:       "2b6187af85a480a5e77c8b39a539b6ecd2e2be2f66314088a97a83024f8bb584"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c6ea34e2f65484ebc2d74c2f658f09ef78e2893bb6ee7f7674f1c72f8d8f98"
    sha256 cellar: :any_skip_relocation, catalina:       "ed1f635a737973af4b9f4f784757cdf0ddbb3f946cb285917c171392a9b59d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "03f604ff4981449be5916104ec86dc67e1c1df565f0f064b9689149f82b9b58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc33f2a8fd3dda76dc87a7a919c7e590a4853a0736bc92c20d25e0d8382db6d"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    ENV.append_to_cflags "-fcommon" if OS.linux?

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
    assert_path_exists testpath/"homebrew.ps"
  end
end
