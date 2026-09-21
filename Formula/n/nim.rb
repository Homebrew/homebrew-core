class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.2.12.tar.xz"
  sha256 "2639a06a5ea7a7fcf57df1e7e1ef4d1b2bee58c7ac9bd00dbd2aa5bea1e5a56a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8822dfac3dcb17d51495233cef89c6f0010b9990d950dcb9c9ad19df543f4b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c9f56f6246e35c2adbe293d1c35f36687a25a6cd7b47305bba7cc71a3e300c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bb64964dfadb7bc00b984dc9efa5bfb190f39e010c8f519f4d4171a7df4adf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bb43c1ee29eb5345b64c9da8c2e4f06c3a391b041fa4c3383247c0b59ebecb25"
    sha256 cellar: :any,                 arm64_linux:       "149ca4284efc1bee86cacbad6a96bd878821163df13ce1144c6f7d653dd4e780"
    sha256 cellar: :any,                 x86_64_linux:      "95d7ee10379cce87bab03c85494959ebacae257d59cc99699221383f12499c8d"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "atlas", "mongodb-atlas-cli", because: "both install `atlas` executable"

  # Replace `pcre` with `pcre2` using commits from an unmerged upstream PR
  patch do
    url "https://github.com/nim-lang/Nim/commit/8c2ec2a7b010ef1a43b967205324ac83d11815d1.patch?full_index=1"
    sha256 "f9171dba1817a83aada2960aab68b988fb6b3e766aa50b9527acc3daeafa6364"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405",
             "https://github.com/nim-lang/Nim/issues/23668"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/817af7edfcfca41e60e07b258c0943613783dd55.patch?full_index=1"
    sha256 "120d313213c34bd3d48ae02baaa84dc5a0e80a88a6cae4de6a6164aefd6ff300"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/ce1761dff9e79d00bc012938ad6be37caa2edcfd.patch?full_index=1"
    sha256 "06ecc37ab1c349a154cf05f1ca468ed0044e59e812d6401fc2a0f076717cbabc"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/cb802af44e3c684a8738684ebdd84df31aeabf09.patch?full_index=1"
    sha256 "b9d5c030510018822c59714f26b933f822e462856f970ec918af6d4c6a9d285f"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/27fc4fedb5c1be6a4ec27f7d0d0c913a63f792b4.patch?full_index=1"
    sha256 "f012298fe2ef8201fc303f8a7e91dcb10662f3382693ec899e0a505dd90872cc"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/0e3ac706156887ce143681da42b21874c2b20774.patch?full_index=1"
    sha256 "625c837b002bfd492b60cecce812ecdd2d42bd4b3117526f6d3004661949ce90"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/07de39cde6341ae278b47d64f73dd9c823dd18c5.patch?full_index=1"
    sha256 "33b5787281af6bcd4c30354de8ad49457a3360f3acfb000230b162aad114fe4c"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
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
