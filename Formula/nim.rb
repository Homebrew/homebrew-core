class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.4.8.tar.xz"
  sha256 "b798c577411d7d95b8631261dbb3676e9d1afd9e36740d044966a0555b41441a"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6da9b8800dc0ed04a52c42b45e9571b023c1775f34ac6e6d432d80ef974cec42"
    sha256 cellar: :any_skip_relocation, big_sur:       "82ddb5ffb529f4754ccbda1cfd39fdffa145f08e7824dd5139f9a4e25912f4a2"
    sha256 cellar: :any_skip_relocation, catalina:      "431720cc75e0b4203982bb27481cee9d2ed16924a56fcc5b1ba56e834f6c4843"
    sha256 cellar: :any_skip_relocation, mojave:        "c491410e36acd9723e4c3827e9bbbded66fcb4bb97c383d34dc82c49d2db9d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8025769966d4c54e25bbe3807c1f6429880074c118f0213a3d817cb62d4113be"
  end

  depends_on "help2man" => :build

  def install
    if build.head?
      # this will clone https://github.com/nim-lang/csources_v1
      # at some hardcoded revision
      system "/bin/sh", "build_all.sh"
      # Build a new version of the compiler with readline bindings
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
    else
      system "/bin/sh", "build.sh"
      system "bin/nim", "c", "-d:release", "koch"
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
      system "./koch", "tools"
    end

    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    system "help2man", "bin/nim", "-o", "nim.1", "-N"
    man1.install "nim.1"

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      man1.install "#{t}.1"
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
