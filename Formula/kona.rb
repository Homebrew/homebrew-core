class Kona < Formula
  desc "Open-source implementation of the K programming language"
  homepage "https://github.com/kevinlawler/kona"
  url "https://github.com/kevinlawler/kona/archive/Win64-20200313.tar.gz"
  sha256 "3238da53bfb668e8b73926f546648bbcfbf2e86848e54c72fd3a794f3697b616"
  license "ISC"
  head "https://github.com/kevinlawler/kona.git"

  def install
    system "make"
    bin.install "k"
  end

  test do
    assert_match "Hello, world!", pipe_output("#{bin}/k", '`0: "Hello, world!"')
  end
end
