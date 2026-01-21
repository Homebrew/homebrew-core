class Nettoe < Formula
  desc "Tic Tac Toe-like game for the console"
  homepage "https://nettoe.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nettoe/nettoe/1.5.1/nettoe-1.5.1.tar.gz"
  sha256 "dbc2c08e7e0f7e60236954ee19a165a350ab3e0bcbbe085ecd687f39253881cb"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f6d3b32a4b364e84aab80cfa135679ec141419e601724888c54a31310cd85d1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3ffd852b505b8793e11f4c16e537613fa07573361b0d6762145ba59727756298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3808e963136d5f0330b4a779f8872cf3ba3a9cbeae5c555cc37bfbefd226173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af2f3dde5a365c56fb7e055b1a4dba60b1af8dfa0bdb02150965d407e1d69f3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e809cedf43aead29ed0e328f3a2a2a3a5cb15b55462392cc94bee353d015ec8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9f2e1b0a27c15f903c42fd54af41f52553d9027cde5aff110e7f8a895b934a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "286be67f32fae34001ff40ee7122b3fc44564b1605cc9a456298dd78ec01c567"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8359f959025e11e174d90006395597eb4caaedaa83e47f75272b34d4ff67e1"
    sha256 cellar: :any_skip_relocation, monterey:       "af7fe17e2294568f6c4140418c1e5ca0ce73daf59dc5defe5036ec611a697666"
    sha256 cellar: :any_skip_relocation, big_sur:        "2387ff01457bbf7019cff906e9503de1b7cc718f055abd3eaa9523b847d951a5"
    sha256 cellar: :any_skip_relocation, catalina:       "59cab1291f69cb1c35a269d18343a3d07eaf55d6f0d178c9548afb282497fc50"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2f2fb05b5054fa36e1dc3164dd500e4a3a9616ad6d2fd515791493859b9a27d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f72b5ebf9338c0c725ee8df4e6843ec8f9a13fbb9935e3bd121ce8302c3ecbbc"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `addrfamily'; nettoe.o:(.bss+0x68): first defined here
    # multiple definition of `NO_COLORS'; nettoe.o:(.bss+0x64): first defined here
    # multiple definition of `NO_BEEP'; nettoe.o:(.bss+0x60): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "netToe #{version} ", shell_output("#{bin}/nettoe -v")
  end
end
