class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.4.2.tar.xz"
  sha256 "b28bf4da1fce46dba9d16685c981b3d5e98de8db1b60d66f279b0bd2af2d8211"
  license "MIT"
  compatibility_version 2
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f647299518dd3a172cab3cea67f8df1ce4cba03f23ea3b140c0a14771b30beca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14e031d28e045c0480509f8f9b9d51f17bee197fc3b57a057ca34b5a43974c7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31ff16855a4b7a29ad845e6a3798eaf133378d9fd2f1876182adc9110269ae06"
    sha256 cellar: :any,                 arm64_linux:       "b0bf88fc433c9b5f2c283de86638c93da6e082dd1b97dbf02b75ec811435258c"
    sha256 cellar: :any,                 x86_64_linux:      "59836c664fa440e916f365f538b43a61ea40f65d41be90aa6632de9ff4b039fb"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@4"
  end

  conflicts_with "atlas", "mongodb-atlas-cli", because: "both install `atlas` executable"

  def install
    if build.head?
      # this will clone https://github.com/nim-lang/csources_v1
      # at some hardcoded revision
      system "/bin/sh", "build_all.sh"
      # Build a new version of the compiler with readline bindings
      system "./koch", "boot", "-d:release", "-d:nimUseLinenoise"
    else
      system "/bin/sh", "build.sh"
      system "bin/nim", "c", "-d:release", "koch"
      system "./koch", "boot", "-d:release", "-d:nimUseLinenoise"
      system "./koch", "tools"
    end

    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    system "help2man", "bin/nim", "-o", "nim.1", "-N"
    man1.install Utils::Gzip.compress("nim.1")

    # Bash completions aren't compatible with old macOS bash
    bash_completion_v2 = share/"bash-completion/completions"
    bash_completion_v2.install "tools/nim.bash-completion" => "nim"
    bash_completion_v2.install "dist/nimble/nimble.bash-completion" => "nimble"
    zsh_completion.install "tools/nim.zsh-completion" => "_nim"
    zsh_completion.install "dist/nimble/nimble.zsh-completion" => "_nimble"

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimpretty nimsuggest atlas testament]
    tools << "nimgrep" if OS.mac? # needs pcre; can use system library on macOS
    tools.each do |t|
      args = %w[--no-discard-stderr] if t == "testament"
      system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N", *args

      man1.install Utils::Gzip.compress("#{t}.1")
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
      bash_completion_v2.install "tools/#{t}.bash-completion" => t if File.exist?("tools/#{t}.bash-completion")
    end
  end

  test do
    (testpath/"hello.nim").write <<~NIM
      echo("hello")
    NIM
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~NIM
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    NIM
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
