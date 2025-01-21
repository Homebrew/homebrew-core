class GitIf < Formula
  desc "Glulx interpreter that is optimized for speed"
  homepage "https://ifarchive.org/indexes/if-archive/programming/glulx/interpreters/git/"
  url "https://ifarchive.org/if-archive/programming/glulx/interpreters/git/git-138.zip"
  version "1.3.8"
  sha256 "59de132505fdf2d212db569211c18ff0f1f4c1032c5370b95272d2c2b4e95c00"
  license "MIT"
  head "https://github.com/DavidKinder/Git.git", branch: "master"

  # The archive filename uses a dotless version, so we match the version from
  # the "Git 1.2.3" text after the archive link.
  livecheck do
    url :homepage
    regex(/href=.*?git[._-]v?\d+(?:\.\d+)*\.(?:t|zip).+?Git\s+v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2918859c7196c31d059c74c800d7207bb77aa90b6b1ee67f07348a8d9871151a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfcee8f4eaa935d5d9ae04a218a2c6e23b3a61dc28efcc07c6e2324951270f52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f35fdcc34084acb96613f2cb035fd16d349fcd7f5dcc82dc33eafe76f45aff12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12fb6bc8de954d79ceb96ea55d9701791e5594a904975bf83ca44553b137c458"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1907bad802aea91587b1a8a1dc2479f141a7e4a29a1456b32554ca9baad1f14"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa6daff0372749efa6ef75264013026afac6860c606213b73d86e3b977ccd20"
    sha256 cellar: :any_skip_relocation, monterey:       "942aadac90c26be5df726e9625f220e1a4cab5c9b576cfd82b168be1f6c3f0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90c71e0a8189e0872070926f2c9e2a5e032e62e11b57738728d9ee640c0d26ba"
  end

  depends_on "glktermw" => :build

  uses_from_macos "ncurses"

  def install
    glk = Formula["glktermw"]

    inreplace "Makefile", "GLK = cheapglk", "GLK = #{glk.name}"
    inreplace "Makefile", "GLKINCLUDEDIR = ../$(GLK)", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../$(GLK)", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", /^OPTIONS = /, "OPTIONS = -DUSE_MMAP -DUSE_INLINE"

    system "make"
    bin.install "git" => "git-if"
  end

  test do
    assert pipe_output("#{bin}/git-if -v").start_with? "GlkTerm, library version"
  end
end
