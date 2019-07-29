require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.3.2.tar.gz"
  sha256 "81fc7e8de484e865c04fda1bf4619030621e261102aa79490a18ab4e4275105f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8fc00cd6d272e33046cd7fad782c4d3f5fccd61d1aaf2ddca92db58acf79247" => :mojave
    sha256 "ff5ed85033e8e8e32cb86bc17ff3fcf61ee3ca4789663a7df73d72b6e538d560" => :high_sierra
    sha256 "e9784c07ce08e7dcc11d779a8357a65d1e2f338349c8466b2262f8695fb9b2d2" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"

      system "make"

      tag = `./bin/dist tag`.chomp
      bin.install "tmp/dist/arx-#{tag}/arx" => "arx"
    end
  end

  test do
    testscript = (testpath/"testing.sh")

    testscript.write shell_output("#{bin}/arx tmpx // echo 'testing'")
    testscript.chmod 0555

    assert_match /testing/, shell_output("./testing.sh")
  end
end
