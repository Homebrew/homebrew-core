class MecabKo < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko"
  url "https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz"
  version "0.996-ko-0.9.2"
  sha256 "d0e0f696fc33c2183307d4eb87ec3b17845f90b81bf843bd0981e574ee3c38cb"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-3-Clause"]

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    rebuild 2
    sha256               arm64_tahoe:   "1dc0d604faa74cae746946732a15747d93933ebb2c5f8f4b04c9a2a491e7d430"
    sha256               arm64_sequoia: "c50f25a8f6a26b3a337386a95f81db1d8f4a5a70b836735dee5b07c054fe74c0"
    sha256               arm64_sonoma:  "7225f4c8b17030c06056d9123b2b715f6c3549a406530bbd0ea1dc74a9d098f2"
    sha256 cellar: :any, sonoma:        "00322405984f46e8b910bc00b7ab65df1337e20dcb61713906db6c65f4b81687"
    sha256               arm64_linux:   "d4e7c616122f4d0a3eaefcdd6dcf6a653290cfdbf2082397eee355ab791ce51e"
    sha256               x86_64_linux:  "1c35b1a6767129996a080135a1091d9c3f732056d1c84fc0d00db95e04953b12"
  end

  conflicts_with "mecab", because: "both install mecab binaries"

  def install
    args = ["--sysconfdir=#{etc}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Put dic files in HOMEBREW_PREFIX/lib instead of lib
    inreplace [bin/"mecab-config", etc/"mecabrc"], "#{lib}/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
  end

  post_install_steps do
    mkdir_p "lib/mecab/dic", base: :homebrew_prefix
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/mecab/dic", shell_output("#{bin}/mecab-config --dicdir").chomp
  end
end
