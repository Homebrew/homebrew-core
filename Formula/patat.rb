class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://github.com/jaspervdj/patat/archive/refs/tags/v0.8.7.0.tar.gz"
  sha256 "7aaa76d2ef07c140d52803b2a62a7ee8b8c850ff6245b036e05afae9bd0b0f39"
  license "GPL-2.0-only"
  head "https://github.com/jaspervdj/patat.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"01.md").write <<~EOS
      ---
      title: This is my presentation
      author: Jasper Van der Jeugt
      ...

      # This is a test

      Hello world

      ---

      # This is a second slide

      lololol
    EOS

    # It is intentional that this string contains terminal control codes.
    expected = <<~EOS
      [33m                        This is my presentation                         [0m

      [34m# This is a test[0m

      [mHello world[0m

      [33m Jasper Van der Jeugt                                             1 / 2 [0m

      [m----------[0m
      [33m                        This is my presentation                         [0m

      [34m# This is a second slide[0m

      [mlololol[0m

      [33m Jasper Van der Jeugt                                             2 / 2 [0m
    EOS

    output = shell_output("#{bin}/patat --force --dump 01.md")
    assert_equal expected, output
  end
end
