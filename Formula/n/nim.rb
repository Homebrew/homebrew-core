class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.0.8.tar.xz"
  sha256 "5702da844700d3129db73170b5c606adbdfb87e82b816c0d91107ea20a65df16"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d67173c53e7bebd0e0dc261e0210cbdeb24685793bf820ac99180b9c6c655d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c51ef71c5a860ce22c8b67d7bbf15124f831b696c295684148c91e5f1d4117a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acd8f8aa1c431b89a15d11303eb2cbe77b7f5d798d3d8ba6ac3d4eff5e85e38e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8e5f3436c33b11f59e7ecb82778adda20cd5c409d495152ee82de08b6d0f851"
    sha256 cellar: :any_skip_relocation, ventura:        "8d308482f8e5691e3ce3f2be6156e6eb7c1df17192eab59113fb108331742a50"
    sha256 cellar: :any_skip_relocation, monterey:       "952bf2723e7410a15627c538d199c598c33c1d9b753e510b25dfba8ae737aaa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3adb4b5fe1f229c6b09018ed07c3489acc2647e06c34cc66948840d4a22fac"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "atlas", "mongodb-atlas-cli", because: "both install `atlas` executable"

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
