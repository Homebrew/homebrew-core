class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.16.0.tar.xz"
  sha256 "9e199823be47cba55e62dd6982f02cf0aad732f369799fec42a4d8c2265c5167"
  head "https://github.com/nim-lang/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c49b41b664900583155879fe3e5e976d139aa6c7b8de73726aeee17c910608e" => :sierra
    sha256 "3dba6e1f780990772bd6da7d542da173807acff84142a132920a99b2f46b1a28" => :el_capitan
    sha256 "602c726784ef9fb42538ac9945c8fad86c4aacdd8a9689f71e04a4d5f9c951e2" => :yosemite
  end

  resource "nimble" do
    url "https://github.com/nim-lang/nimble/archive/v0.8.2.tar.gz"
    sha256 "5cfdebdeddf5cf7d32c7b1b047a99d660de4e3a29e29ce7a3216020dc4f301cd"
  end

  resource "nimsuggest" do
    url "https://github.com/nim-lang/nimsuggest/archive/v0.15.2.tar.gz"
    sha256 "432f45af20f0e5b158a1fec43f733f71f1f7d36efccba9db04d3b0d4e13f4a4d"
  end

  def install
    if build.head?
      system "/bin/sh", "bootstrap.sh"

      # Grab the tools source and put them in the dist folder
      nimble = buildpath/"dist/nimble"
      resource("nimble").stage { nimble.install Dir["*"] }
      nimsuggest = buildpath/"dist/nimsuggest"
      resource("nimsuggest").stage { nimsuggest.install Dir["*"] }
    else
      system "/bin/sh", "build.sh"
    end
    system "/bin/sh", "install.sh", prefix

    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"

    system "bin/nim", "e", "install_tools.nims"
    target = prefix/"nim/bin"
    target.install "dist/nimble/src/nimblepkg"
    target.install "bin/nimsuggest"
    target.install "bin/nimble"
    target.install "bin/nimgrep"
    bin.install_symlink prefix/"nim/bin/nimsuggest"
    bin.install_symlink target/"nimble"
    bin.install_symlink target/"nimgrep"
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<-EOS.undent
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"", shell_output("#{bin}/nimble dump").split("\n")[1].chomp
  end
end
