require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.2.3.tar.gz"
  sha256 "3becc8cd5404b0b9651ccc0ec9a3cb2d58ca84194153aa7530a424cc9a55c0fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7a893f1bf1685cca2e36ccb3f82855350b55d39ebd07b8255f274ffbb1215fc" => :mojave
    sha256 "bc4fc482effff6cf3fa25c359640e7ec9739e7ce048cdaf26b9fda459870c8f6" => :high_sierra
    sha256 "f36dbf51a7bd08e5e5b9923c7d39e276c3405ccae326016e70c1ea730fedd7fa" => :sierra
    sha256 "53e9ec5f8017204e3c97f88c7a57f1701a5243af64e02f00e728625db58ec818" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Remove for > 0.2.3; GHC 8.4.1 compat
  # Upstream commit from 25 Mar 2018 "Updates for new Cabal, GHC and base libraries"
  patch do
    url "https://github.com/solidsnack/arx/commit/8ec85a7.patch?full_index=1"
    sha256 "fc40c128c7aeee75e3ddd10b3df8a81e35b6092ad61efdfa968fd84d50355cf8"
  end

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
