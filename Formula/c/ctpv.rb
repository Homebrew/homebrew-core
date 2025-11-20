class Ctpv < Formula
  desc "Image previews for lf file manager"
  homepage "https://github.com/NikitaIvanovV/ctpv"
  url "https://github.com/NikitaIvanovV/ctpv/archive/refs/tags/v1.1.tar.gz"
  sha256 "29e458fbc822e960f052b47a1550cb149c28768615cc2dddf21facc5c86f7463"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "891ba106991bf7d6a64f1216540cb3332c5eed558e8b7c30733d1d47b766d5dc"
    sha256 cellar: :any,                 arm64_sequoia:  "37152d389946123d23de9ee5d1bcda011032a94ba42e1df5ce82363c4224ae56"
    sha256 cellar: :any,                 arm64_sonoma:   "5b92c898bfc950574c2a7b15d19dc064610d2a7df9c0825839ae83d864d49a35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07d558283ff80cd3054aee902b229c0c0b23ae63190cb2ea1d0b235e1263ec15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5071c8b89a29f293d184780ec3214faca02fc5196329043f99a8cff76657982a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98372ed14dc5b89f3b3e6fabdd24b51c754d081e04a5177dbf0f3fd2a8aa3eea"
    sha256 cellar: :any,                 sonoma:         "0b11166fde3dd51d0ca4419bbf8457858f139e1eeb23cdba43749b3742b71c7f"
    sha256 cellar: :any_skip_relocation, ventura:        "885b4e98aa3ba62f36f7924dd6a4006aaf873bed1c5aeb30fc6599413e48ca03"
    sha256 cellar: :any_skip_relocation, monterey:       "7749f4c22614e7fbb0724661417495a36559551debb40f76e5e85cf507d2a86b"
    sha256 cellar: :any_skip_relocation, big_sur:        "13ba1dd46f7dd11e21a82467ed1fd1640308482e789b8236fffe612e0f4280b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cc5045108cb40264a0d6870ca7c21f4d32be00b365d47af2d659523a46406f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c9583347b626f784679ab68dccf83766e98d58b0fb1357a4852271f92a1161"
  end

  depends_on "libmagic"
  depends_on "openssl@3"

  fails_with :clang do
    build 1300
    cause "Requires Clang 14 or later"
  end

  def install
    # Workaround for arm64 linux, issue ref: https://github.com/NikitaIvanovV/ctpv/issues/101
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    file = test_fixtures("test.diff")
    output = shell_output("#{bin}/ctpv #{file}")
    assert_match shell_output("cat #{file}"), output
  end
end
