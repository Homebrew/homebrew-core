class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/refs/tags/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 4
  head "https://github.com/xach/buildapp.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "41ea69cf949b8ef0f20b9b174f782e0ff539ed9f0fd6de9e75b20870a4464396"
    sha256 arm64_sequoia: "5478cbb2fa632a52202bc864bca54bf1e53dd679a53f89b03745180b2e1d7edc"
    sha256 arm64_sonoma:  "3106074e9f1ca504946ce090f23fec209d395817a9afdd7627cda2dea601f70b"
    sha256 sonoma:        "1bcb452e9daa0bf6c79342e5787a27e4d8f4b09d710eb28d67040c08b9fdd4b7"
    sha256 arm64_linux:   "012afed152e0cee571cac5c5c8ea20670d0827bf45a04db711019a67a9c081b5"
    sha256 x86_64_linux:  "8dccd3fc72893770eda060bd3bba1f13eef10816c5592842f8d6b172d8fed952"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"

    # Work around patchelf corrupting the SBCL core which is appended to binary
    # TODO: Find a better way to handle this in brew, either automatically or via DSL
    if OS.linux? && build.bottle?
      cp bin/"buildapp", prefix
      Utils::Gzip.compress(prefix/"buildapp")
    end
  end

  def post_install
    if (prefix/"buildapp.gz").exist?
      system "gunzip", prefix/"buildapp.gz"
      bin.install prefix/"buildapp"
      (bin/"buildapp").chmod 0755
    end
  end

  test do
    code = <<~LISP
      (defun f (a) (declare (ignore a)) (write-line "Hello, homebrew"))
    LISP
    system bin/"buildapp", "--eval", code, "--entry", "f", "--output", "t"
    assert_equal "Hello, homebrew\n", shell_output("./t")
  end
end
