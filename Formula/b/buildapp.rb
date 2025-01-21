class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/refs/tags/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/xach/buildapp.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "25eba8ba9388bbf422a7a5f14e2db9f1ea8d9e9add5cd58aecb3ea6a97f7eb83"
    sha256 arm64_sonoma:   "4cd0afa49db04a858b694e03cb247d5fc67b5c73b082725032364102b6e24973"
    sha256 arm64_ventura:  "41ce31edf3763b06c08acd06abfcfaecec13bfa0487d876ca37019f2aea85ead"
    sha256 arm64_monterey: "071a97e829ed1ca27927b7bb4539a552cc1a26f671f83d23cad621ad13b3cb4a"
    sha256 sonoma:         "d54e9bdbef32deb80e6dcf9ad7089ae433e9594fd3fc8df6e1ae50065a8e2857"
    sha256 ventura:        "e74370d3c6b1367de4d8edcee76878f8a380d7728f43f18cf4e2b28d6acb609e"
    sha256 monterey:       "8c4d8793f2467b30a89079fd58099a79d331794d3667949736b91542279d1b6c"
    sha256 x86_64_linux:   "4642b29de810bdc8d7c9d5e1ea678c5f366dee7a3dd6ca48523dd36af4f559ea"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    # Fails in Linux CI with "Can't find sbcl.core"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    code = "(defun f (a) (declare (ignore a)) (write-line \"Hello, homebrew\"))"
    system bin/"buildapp", "--eval", code, "--entry", "f", "--output", "t"
    assert_equal `./t`, "Hello, homebrew\n"
  end
end
