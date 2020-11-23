class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.2.3/hlint-3.2.3.tar.gz"
  sha256 "a0a3a6a744b777ea653f3dad14b928c646e8979c611a4260bc0ca4cf76cdcdf8"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3c803db5c30eda436b2fa3b234d197e0dfd3d13ede02a639664d552a6861f1f4" => :big_sur
    sha256 "72f676c41320a1dab84cfdcf59abaf9e12288fe2caf5d9866f8b735f52fe395b" => :catalina
    sha256 "dfba8dc29f88647e7ec3002de72f0c684c50d194690e020953a133635b379c72" => :mojave
    sha256 "0685232ecec8f66640c740882e98be03d92b8296f1240bec42079b07392110d2" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "No hints", shell_output("#{bin}/hlint test.hs")

    (testpath/"test1.hs").write <<~EOS
      main = do foo x; return 3; bar z
    EOS
    assert_match "Redundant return", shell_output("#{bin}/hlint test1.hs", 1)
  end
end
