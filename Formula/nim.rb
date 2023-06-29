class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.14.tar.xz"
  sha256 "d070d2f28ae2400df7fe4a49eceb9f45cd539906b107481856a0af7a8fa82dc9"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0d657335f096e22180b7d923572298bc1f9c39c78d173674d90db1a5ea0fdf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17a89c77be7b79a5ad4da17848db599144cc1b6e8b56da67b735167c859aecb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df0a7ffb4c7971ebb3f889ca6c295da03d0dba830e489cd6accd1de48b5a8087"
    sha256 cellar: :any_skip_relocation, ventura:        "909f00f8b3404a67ad16b7b817731eff8c026c338783452b6803125882853b15"
    sha256 cellar: :any_skip_relocation, monterey:       "1422b265bf8e39928c9712007e45b987719c3c85e033f9bf30529d1918391934"
    sha256 cellar: :any_skip_relocation, big_sur:        "545546c1969539b9b825467f0d816afbcdf6c08d028224a9483701635a1d7bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7f17b6b94df0553b383e31ffd501e65325ec598096fd4224f0e761d9b7f32f"
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
