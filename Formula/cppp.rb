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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d662c559bb4dfaa15138640582c608f8ab56b0e111b3c26c74263d25c81587"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cd55985b76fc022d9fac25b65381665062c9000e7809eac2f59fbc62aa7f0d8"
    sha256 cellar: :any_skip_relocation, monterey:       "c6dfe163a83d88690f4c009a03426a3902c296753c3c4f3b71265d8cbfee07ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3af87be706f4748b1a7d0376fa8a0722ea0c657aeb6ad4cc4ca179b0d2f00d5"
    sha256 cellar: :any_skip_relocation, catalina:       "6490ca9165fa53a8d1c9727f1ec1d47d3231fb7d29aa1081257e70cadcb929fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b80570f70b9606af2e31a1b0a09a9d8f57fd10bcd0797c2ea4feb39063caf64b"
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
