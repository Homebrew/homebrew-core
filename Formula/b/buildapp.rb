class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/refs/tags/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 8
  head "https://github.com/xach/buildapp.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "d0e1979e97575ec9a8424f7fc470b16751957accb1d6e5975e7ede5b4c98de00"
    sha256               arm64_tahoe:       "0d9c0ca6de78c19abe72228d5e2d6d99ce3f254e10d1bc98d119159e5cafbea1"
    sha256               arm64_sequoia:     "eac8a81872f14a5d798d9026ae9dfa55afbca961e577b5de151e5570de8e86f8"
    sha256 cellar: :any, arm64_linux:       "ef3cb341bc9462a229c4e0d9951c59a45b5968b73930b0d9231ceeab7a28c9e5"
    sha256 cellar: :any, x86_64_linux:      "d31814eb74d0890d76c116103d8d9c436c848de3032b3c3d7ece56b8ab0b6cea"
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

  post_install_steps do
    install_gzipped_executable "buildapp.gz", "bin/buildapp"
  end

  test do
    code = <<~LISP
      (defun f (a) (declare (ignore a)) (write-line "Hello, homebrew"))
    LISP
    system bin/"buildapp", "--eval", code, "--entry", "f", "--output", "t"
    assert_equal "Hello, homebrew\n", shell_output("./t")
  end
end
