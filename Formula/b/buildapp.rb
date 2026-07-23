class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/refs/tags/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 5
  head "https://github.com/xach/buildapp.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "cf2b7b0cc23504aaff7179e0e59c1207f3701b5a33e3db9eabcc3a3daf5cf56e"
    sha256 arm64_sequoia: "dba1918cfcfa84ad70b3096b5c82363ed008343a0415e2c5970351e5c75611d0"
    sha256 arm64_sonoma:  "3dde5b03d5c26fb6cd620392adc04e6c4d76660b7466750b501ec5f44af47526"
    sha256 sonoma:        "9d0c20f7518afed5c450086506b07e5bdd2a984356120d71c80c2fdb91b2f23e"
    sha256 arm64_linux:   "74de869f82575c8899fdf1066a5fcdd5be333ed330a52777fc3a38ff0e33cb75"
    sha256 x86_64_linux:  "e6998297a1d472906177a1c4d2a4e146c70ba88902c195f4dd75c2fe53db039d"
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
