require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.2.2.tar.gz"
  sha256 "47e7a61a009d43c40ac0ce9c71917b0f967ef880c99d4602c7314b51c270fd0f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "176b98514ed7621547c235a216b38e31028001943dff1184f37677ca9651ac18" => :sierra
    sha256 "afdd553d853afe2e679d56d93407b4031262ff41475dccc747ef0e57c7d01f7b" => :el_capitan
    sha256 "47d9f6b76fe542ae8553a9c7ad56eaecd59a755210be97265774949e67562936" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
