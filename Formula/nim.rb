class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-0.17.0.tar.xz"
  sha256 "36e18dd9384f6c67e6d0199b871b43e774a0af30532698184d6f5a9cc9ac7a9b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f026a07f779040c1b4e53448b344856e7375bc68c4a00992eaae98b90927ef28" => :sierra
    sha256 "1e402f8c34ceeaa674a7d9864509db19689e3f98817e8ba1d0ec7807e834c8d1" => :el_capitan
    sha256 "c45e4b32b58b95cd4415095281cca6efa33f3ac230fe60a063a7a196428939b0" => :yosemite
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
