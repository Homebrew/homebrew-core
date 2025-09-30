class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "https://libslack.org/daemon/"
  url "https://libslack.org/daemon/download/daemon-0.8.4.tar.gz"
  sha256 "fa28859ad341cb0a0b012c11c271814f870482013b49f710600321d379887cd1"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?daemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9accc09cd67f7ea55479b1d0aec44f2fc6a2d88df38e3d93e51900b970ae8f29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f167ab77722eb90a0346e5ecaaef90b7e4c25dc74ad5ce5797d3417cc4d672e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3632a8d5eb5d95e5b9df3741e91a1de29f493fc755f9fd6b4e64a10edcea5ddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "101e6130d15ab59ff302b56ac933ec41f4daf94820e0177acd7b500c6afabc29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91563d72f29b423fb13d3b486e8e6bc0b8e1bf8d8d1a682df7b4ae14da077855"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76f97fb46b1d1568f0cdf54c251c187c9cb5e0205e9951fae178d09e13ac5aef"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d183e8493116bd6a715e34ae2db121fe7b6c04b2f6b255daf6c171ddda1510a"
    sha256 cellar: :any_skip_relocation, ventura:        "fbe58edeb92d71e3ba4e5e7f3f6e9bfd5cb9710357bbd6098c92065f38d27b62"
    sha256 cellar: :any_skip_relocation, monterey:       "708784508effbf7aa7c2d5680fd52c7c1ae572ffdbd08d672d8ec7eab33534f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab2a22bdc41a9a0a551bf77c6ea2ad5f3a75b6ad75def292d6ebd4f59979ce93"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "87c4ae0cde212781fe52c0ac599a2b867063595596d7b3260497969b9d610f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861a0eb58cced7a2c88edb3309eef07521084b317725b9fe4f67acf71b83f331"
  end

  def install
    system "./configure"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"daemon", "--version"
  end
end
