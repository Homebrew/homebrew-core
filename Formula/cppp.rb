class Cppp < Formula
  desc "Partial Preprocessor for C"
  homepage "https://www.muppetlabs.com/~breadbox/software/cppp.html"
  url "https://www.muppetlabs.com/~breadbox/pub/software/cppp-2.8.tar.gz"
  sha256 "a369cec68cbc3b9ad595ee83c130ae7ce7d5f74479387755c22a4a5ff7387ff5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cppp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c7e7662822fbe71dbfd415f18987b2f4d3213964b4cb29c63ff5c5309da4568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd8536a2f531ecf9e8de49d13f3f1479307ea83087f52d34a106ac0015b1c511"
    sha256 cellar: :any_skip_relocation, monterey:       "24b11b6ca7f8f06f0b79145b3a7364678f69b25eba90231a6809a7c8bdd402b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9af5eecf774998c43a7355e9d3751bbea079282a6df1acbfa9003e123bfe383"
    sha256 cellar: :any_skip_relocation, catalina:       "8f99bf2fa57d4a16f4a198841bbd878fdf11b94eaadff0fdd54e71c3b229864e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdbacd12270ad5f7276b58daba29cffad0a995bfb895e375edb5a5e5a49c1698"
  end

  def install
    system "make"
    bin.install "cppp"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      /* Comments stand for code */
      #ifdef FOO
      /* FOO is defined */
      # ifdef BAR
      /* FOO & BAR are defined */
      # else
      /* BAR is not defined */
      # endif
      #else
      /* FOO is not defined */
      # ifndef BAZ
      /* FOO & BAZ are undefined */
      # endif
      #endif
    EOS
    system "#{bin}/cppp", "-DFOO", "hello.c"
  end
end
