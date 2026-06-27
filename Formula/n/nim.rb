class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.2.10.tar.xz"
  sha256 "7957b7ed004206bcf10bcc4f3b4744153878e62f2431552a9a8e9d3f40e8d5d5"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9562f3177bbc268b4cb77396ba673a463b306f3911372063c8fe36942e848f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dd6d0afe58bda10dfb591a4f9e60db7f095f02cb6f9f1e0c740895b088a06f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d67c02cc0c3b10da447be6fc6320c4951202328864992de6e06034b14dead08"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a114ab549a17345feca2d5a3e9770a9fe1e0342278de34c13469495bfe5b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a953d392c026e0affc4cc1d57d79a4fbddfdaba80bba2c639a5d98b1698ab6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5fc2ecd28eb33dec002d3c0f5ebc8e2e29b80d226bba0e59ae2f837791e673"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "atlas", "mongodb-atlas-cli", because: "both install `atlas` executable"

  # Apply commits from open PR to replace `pcre` with `pcre2`
  # PR ref: https://github.com/nim-lang/Nim/pull/24405
  # Issue ref: https://github.com/nim-lang/Nim/issues/23668
  patch do
    url "https://github.com/nim-lang/Nim/commit/8c2ec2a7b010ef1a43b967205324ac83d11815d1.patch?full_index=1"
    sha256 "f9171dba1817a83aada2960aab68b988fb6b3e766aa50b9527acc3daeafa6364"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/817af7edfcfca41e60e07b258c0943613783dd55.patch?full_index=1"
    sha256 "120d313213c34bd3d48ae02baaa84dc5a0e80a88a6cae4de6a6164aefd6ff300"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/ce1761dff9e79d00bc012938ad6be37caa2edcfd.patch?full_index=1"
    sha256 "06ecc37ab1c349a154cf05f1ca468ed0044e59e812d6401fc2a0f076717cbabc"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/cb802af44e3c684a8738684ebdd84df31aeabf09.patch?full_index=1"
    sha256 "b9d5c030510018822c59714f26b933f822e462856f970ec918af6d4c6a9d285f"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/27fc4fedb5c1be6a4ec27f7d0d0c913a63f792b4.patch?full_index=1"
    sha256 "f012298fe2ef8201fc303f8a7e91dcb10662f3382693ec899e0a505dd90872cc"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/0e3ac706156887ce143681da42b21874c2b20774.patch?full_index=1"
    sha256 "625c837b002bfd492b60cecce812ecdd2d42bd4b3117526f6d3004661949ce90"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/07de39cde6341ae278b47d64f73dd9c823dd18c5.patch?full_index=1"
    sha256 "33b5787281af6bcd4c30354de8ad49457a3360f3acfb000230b162aad114fe4c"
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
