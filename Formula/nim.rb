class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-0.17.0.tar.xz"
  sha256 "36e18dd9384f6c67e6d0199b871b43e774a0af30532698184d6f5a9cc9ac7a9b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9c0a2cdbffa036300c3f7ae585cfce2935c7cd9d0578c9b81f78b3e1b24d044" => :sierra
    sha256 "50393a7272a8764e545d44fc9e61b0f61d2ab7272999a268773781efb0e3e2fa" => :el_capitan
    sha256 "ff32d6a8738a54cacca65db0852c678d54d80de5034b545b518107d49a16f736" => :yosemite
  end

  head do
    url "https://github.com/nim-lang/Nim.git", :branch => "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        build_bin = buildpath/"bin"
        build_bin.install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimsuggest/nimble/nimgrep
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix
    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"

    target = prefix/"nim/bin"
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
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
