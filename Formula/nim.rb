class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-0.18.0.tar.xz"
  sha256 "2ebe164eb4638a7a65aa02da7bdc4d7559026105655fdf3f620b9525406a46c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f976e6aecf9c6211eab818ab86b3f7ee42d9ff2c02cd272017ba12657fd9353b" => :high_sierra
    sha256 "2bc6629eb88e0c023f62e486ef45cfb31756e6c5fae5726e1cc243f6bb091f22" => :sierra
    sha256 "b18b6e44b530db76c429f6be3ef367dc993cf1f78956f006d1dcf7cd5c465cfb" => :el_capitan
    sha256 "99e962cbea6146efceba1e7eed10bea6e1ce84d8715571f57078e7e736e67751" => :yosemite
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
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
