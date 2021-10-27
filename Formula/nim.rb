class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.6.0.tar.xz"
  sha256 "52065d48d72a72702ec1afe5f7a9831e11673531e279cdff9caec01a07eec63d"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2752c65069f4a92c529d85dd60b5aa21d557b7753d25b875d01e0931238b7747"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76f0e1b7db990f867bdbf97db92fcdb9a96de73733eb29a33878f8935a27214f"
    sha256 cellar: :any_skip_relocation, monterey:       "6bed54ef25269f67f8fb04a0339b726ac74b5dffa698ef2e0041dc76fea33063"
    sha256 cellar: :any_skip_relocation, big_sur:        "b44d54cb206ab367dc6af6bfaf2b88a093369b95344f068bc8a71c8c99ba2406"
    sha256 cellar: :any_skip_relocation, catalina:       "2662f8654a5bba61c293513cccecf72ce54e9a5a17aff9373a516087c999630e"
    sha256 cellar: :any_skip_relocation, mojave:         "3cad9495839a01078ff66b0f8db540ca038c5ebf11b9ecd070a9d297d2193616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db63f1cd066553a0bd0c7b8d38cd171876bef75da13b4783fc3927bf323846b4"
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
