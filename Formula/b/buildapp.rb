class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/refs/tags/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 6
  head "https://github.com/xach/buildapp.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "d494dda9984b4ffa898a312898da4639e0844322ab8b716916dc556bc0711e4a"
    sha256               arm64_tahoe:       "3d82cd94f66c4729c19620e8c226b13f575f9e9137fa54132fcc40c27f8398cb"
    sha256               arm64_sequoia:     "d56a8c04e6c3c2088fdf197400f642840815bbeace5c28ffe652d2a7ffa9ed56"
    sha256               arm64_sonoma:      "a7fb1b444eae795648703680aa10512d68a9c64726ec2557639f8eea955847d5"
    sha256 cellar: :any, arm64_linux:       "40293c0cbd6e99e1299a3fbdf7b70fe88f0ed9a44f019a6ee82f74e87660355e"
    sha256 cellar: :any, x86_64_linux:      "7fd3555b69e16ff7b0d922debb3686e062dc6b50da384f384d9477ecdb72d486"
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
