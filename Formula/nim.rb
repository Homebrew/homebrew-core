class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.12.tar.xz"
  sha256 "acef0b0ab773604d4d7394b68519edb74fb30f46912294b28bc27e0c7b4b4dc2"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf36f58ef112d7fe67e6caba6518ad9cf580cdcaf38699c05d4031175067b4f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef6f073f3f66083951c182464de7b42ccb7c3f79ee0be81681b2a903c82317f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9aed521e02999aaf9006697738c8acbbb8467bca753be0622a447632fdd5fb52"
    sha256 cellar: :any_skip_relocation, ventura:        "5f353709c3a269ca11ff0b75f8ee741072c6ac384b30b82af26624fa93ed6d78"
    sha256 cellar: :any_skip_relocation, monterey:       "16264b43aedfffc39e7eae39da2c1823cbf4f92b77f9034b166ea76e71ed2a43"
    sha256 cellar: :any_skip_relocation, big_sur:        "f642ff71fa6ae248f9a29c6135c27e03af3bdbd0e7117a710eef1bd718092cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d29b6cc6736daf2cddf6a2f1b241229ecbd1d256d9ab5fe724b53c2f6ed095"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

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
