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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59f47b5ce3259bbc152a308e97fc81aa1b7b15b44f67d547491d5935e90f126b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "870cfb16af54acd490428b90cf1e6b91427d65d2a10008f4e9347093ef7ccc48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "960bc7cd86d2acfd422caf0f509fb8c165596bcc05e36bb671edfd42f30c782f"
    sha256 cellar: :any,                 arm64_linux:       "4dd0cdff206d7aac309301d241ebe427104584250af9ae2246ad2f7a336cce88"
    sha256 cellar: :any,                 x86_64_linux:      "493fdba051c04c38ee4bb898c7dbf685b0cac29d157a2d30e3c363f326029022"
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
