class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20260721.tgz"
  sha256 "62bdf59057d4f760a1cc2217827f07887b4a3eebf694c25eacd4803d2171cdc6"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b080dfe54929c983bb05fe717120f64d4e242f80539f53e28367e1e60f19939f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07cc731b4a83f15753efa7e2d25f90e381bad5900093ebb1b3da3e4859703d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13d7f3e417c2291b3aa6015b17facde69ffa465a9ab8ce4a5e3ce282c288ecf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b5680449beb52c5db20c0eca85d8b770a3521aad7a4522df35055123472be6a"
    sha256 cellar: :any,                 arm64_linux:   "d72065a2cb2bdb7346811ff99df5d4731a91219ed2b69a47d4231d7b55da0387"
    sha256 cellar: :any,                 x86_64_linux:  "2eb833f02cb7677d117b2e153b8ca5d5ed3f931513fe8212c25479afea9ff843"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system bin/"dialog", "--version"
  end
end
