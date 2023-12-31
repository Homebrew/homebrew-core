class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.0.2.tar.xz"
  sha256 "64f51d3bf56de9d0ee79e2ca6a9ce94454af9a63a141a6969ce8c59a60b82ccf"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d46e5355c8cfcb673980f51c789db1a05a5492031d23e85f5590516f1360e9bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70c3d63ebee38e1f1cdf84fe330b8d4edfb64c8164ba384e38c7118db72b90e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aff52dd1c93f227c5e32b0fe1db93067b79dfbc7561bbe18588ad712626c9a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "789fa390369a17637c717beec449fb8dc8ea0fbc92c568fd73e1ca17b29a414f"
    sha256 cellar: :any_skip_relocation, ventura:        "859b3555ff4f30f204fbd7795434414696a2f5fbbdb13847f3479670dacd578d"
    sha256 cellar: :any_skip_relocation, monterey:       "651beee61a1fe9e6ed554baa391bda2e7913c147266426e5bbce6a5fb9f50184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd8649dc02e0a4522ac07b0c3f6a988e0923c279ba57327ed6938ae6a9db351"
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
    tools = %w[nimble nimgrep nimpretty nimsuggest atlas testament]
    tools.each do |t|
      if t == "testament"
        system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N", "--no-discard-stderr"
      else
        system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      end

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
