class Mosml < Formula
  desc "Moscow ML"
  homepage "https://mosml.org/"
  url "https://github.com/kfl/mosml/archive/refs/tags/ver-2.10.1.tar.gz"
  sha256 "fed5393668b88d69475b070999b1fd34e902591345de7f09b236824b92e4a78f"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "12330982905c21a44082b1c229a6cc82a7347b83dd8112f1d87a5303199637e0"
    sha256 cellar: :any, arm64_tahoe:       "1a7e823a23f184f14b86c7f1c09aae850e733352f8b369a7460a4b4dffb2f7ab"
    sha256 cellar: :any, arm64_sequoia:     "e7767561750b13027b053e1a080b8bcac8d5e34bfdff98089b4e51c4c0c9e8bd"
    sha256 cellar: :any, arm64_linux:       "4664f97ff7d7e8b3564a4fbef73d34e6823320a76a4c5e0cf0591fcaff9b096c"
    sha256 cellar: :any, x86_64_linux:      "4f1904f936092b64032a55a37510d8e865051485ee6ca7efd5b0d6a0cceacb58"
  end

  depends_on "gmp"

  # Backport missing headers to fix build
  patch do
    url "https://github.com/kfl/mosml/commit/52b00ca99dcd77d64dac5a7600fe64a76ed1ac3a.patch?full_index=1"
    sha256 "e0db36e944b5d60e0e98afd3f3e9463d193ae89b7aa66d2cc7c452c6c6ed8632"
    type :backport
  end

  def install
    # Work around for newer Clang
    ENV.append "CC", "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "make", "-C", "src", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "world"
    system "make", "-C", "src", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "install"
  end

  test do
    require "pty"

    _, w, = PTY.spawn bin/"mosml"
    w.write "quit();\n"

    assert_equal "I don't know what to do with file \"foo\", ignored", shell_output("#{bin}/mosmlc foo 2>&1").strip
  end
end
