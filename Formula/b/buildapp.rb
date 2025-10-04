class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/refs/tags/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/xach/buildapp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_tahoe:   "1b91e415cf7ddeab7dc5585efe5b7e58d4798f336ae19bd8c33ebd4d24b19e58"
    sha256 arm64_sequoia: "a424c9298996d720b76dd934de8ba4f8fb90f30b05ab3a8f2916ff351bbe8318"
    sha256 arm64_sonoma:  "3c6c239c61b755cf08e189979db5dfc599111067973befc8fa7155986a2d2e6f"
    sha256 sonoma:        "e832088898a11ef56ff0b5000b5166df15e600d78da05b7061b1917ff932c90e"
    sha256 arm64_linux:   "25b50dc88f92ffa69a1ca5f768b1b50338b37f3ff32078a93492e29b3f66b56b"
    sha256 x86_64_linux:  "7fd612c69baa9387a3790c750c5fc8eb3a7c9787e9107cf7fb200aeb3d184f3b"
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
