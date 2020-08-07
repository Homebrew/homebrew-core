class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.2.6.tar.xz"
  sha256 "df88ea712e96ea847b610d56ef69f46ba587002052a46bf03c5c62affac7657e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaf875cdb7455b97b0584423bc89f13a7fb2f03db4b6eff90c4a1450272701ab" => :catalina
    sha256 "75b50a98e4c5346c384ded525e0b24fc3c88cabcacd2aedc0a883acf6b3c004d" => :mojave
    sha256 "ca9e1c7d809861ee7b8d250803cb7340afe91cf139a87cdd595c74e2e07a2d60" => :high_sierra
  end

  head do
    url "https://github.com/nim-lang/Nim.git", branch: "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        (buildpath/"bin").install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimble/nimgrep/nimpretty/nimsuggest
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
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
