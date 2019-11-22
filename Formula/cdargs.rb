class Cdargs < Formula
  desc "Bookmarks for the shell"
  homepage "https://www.skamphausen.de/cgi-bin/ska/CDargs"
  url "https://www.skamphausen.de/downloads/cdargs/cdargs-1.35.tar.gz"
  sha256 "ee35a8887c2379c9664b277eaed9b353887d89480d5749c9ad957adf9c57ed2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f5fdbb4fdbe3d4dfcb5d45368b91d1ce9c8610902f36e6d28e2d185d2b2185d" => :catalina
    sha256 "d06682d3e4d5ad57b05b00ee2d15f6b34da528e420ea038604b4897c570efd8d" => :mojave
    sha256 "10a170bfe1b70f6c8909ddb6fb88b7615219d6847576e72ee1e4011aba482e9b" => :high_sierra
    sha256 "5ba84d6dff14f5743296721a91e6d01ce984bf6e4589ce2128041b1ed9560a3a" => :sierra
    sha256 "de9d5777eb0179f9ffacb5bcbb0ff0ce7f0c1fb208bb992290eb5a36e1d3f159" => :el_capitan
    sha256 "cf098fc4187835ef1c970b38ab41719e0900c01d2772572f697e9773a6c632e6" => :yosemite
    sha256 "2bb555d4cf65f3d11595350135582599fd6ccf988bc7bb76c58155ddcef29223" => :mavericks
  end

  # fixes zsh usage using the patch provided at the cdargs homepage
  # (See https://www.skamphausen.de/cgi-bin/ska/CDargs)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cdargs/1.35.patch"
    sha256 "adb4e73f6c5104432928cd7474a83901fe0f545f1910b51e4e81d67ecef80a96"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install-strip"

    rm Dir["contrib/Makefile*"]
    prefix.install "contrib"
    bash_completion.install_symlink "#{prefix}/contrib/cdargs-bash.sh"
  end

  def caveats
    <<~EOS
      Support files for bash, tcsh, and emacs have been installed to:
        #{prefix}/contrib
    EOS
  end

  test do
    system "#{bin}/cdargs", "--version"
  end
end
