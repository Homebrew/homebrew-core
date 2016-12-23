class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.15.2.tar.xz"
  sha256 "905df2316262aa2cbacae067acf45fc05c2a71c8c6fde1f2a70c927ebafcfe8a"
  head "https://github.com/nim-lang/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c49b41b664900583155879fe3e5e976d139aa6c7b8de73726aeee17c910608e" => :sierra
    sha256 "3dba6e1f780990772bd6da7d542da173807acff84142a132920a99b2f46b1a28" => :el_capitan
    sha256 "602c726784ef9fb42538ac9945c8fad86c4aacdd8a9689f71e04a4d5f9c951e2" => :yosemite
  end

  resource "nimble" do
    url "https://github.com/nim-lang/nimble/archive/v0.7.10.tar.gz"
    sha256 "9fc4a5eb4a294697e530fe05e6e16cc25a1515343df24270c5344adf03bd5cbb"
  end

  resource "nimsuggest" do
    url "https://github.com/nim-lang/nimsuggest/archive/1bf26419e84fab2bbefe8e11910b16f8f6c8a758.tar.gz"
    sha256 "87c78998f185f8541255b0999dfe4af3a1edcc59e063818efd1b6ca157d18315"
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
