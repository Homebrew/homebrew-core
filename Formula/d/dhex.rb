class Dhex < Formula
  desc "Ncurses based advanced hex editor featuring diff mode and more"
  homepage "https://www.dettus.net/dhex/"
  url "https://www.dettus.net/dhex/dhex_0.69.tar.gz"
  sha256 "52730bcd1cf16bd4dae0de42531be9a4057535ec61ca38c0804eb8246ea6c41b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?dhex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c43035367348acd1ea2109bfcae68108766e691eeaaf7b921f68e9306f7d9fec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6ce6ef0c4079748f07bbfb1f8f74f39caf377df59e244555fe508c63c63367a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68ccfb4eef2b7a798087917073187eb465e01ff7e1b3f2401c0633006a5f1fd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f68e9a14828f6b1bcc452d2f688322b36385e432c7bdc68caa8cc8fa10eec311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c9245918065f6ea1718b437f6d051a05eee5a907c718fdd91fa13221e96d0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b2818af033ee41f28f7718a9a310dc32b2b54272f7485934a643571e54b65b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6e4078e248b7f71461f25a8fce9e45b69dfb122f768c2c81e467ed22b54aed9"
    sha256 cellar: :any_skip_relocation, ventura:        "7b69d79912f98bbfc1b01b2bace2f9c93f9aa33ec31054ffd8195df35c0b8529"
    sha256 cellar: :any_skip_relocation, monterey:       "da93104948edb1bfa1ceec708ab498d2b14bfee4a873ed9dff599a450698c50a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9737b2072e10b36cf34973fb1a18fbbdd570bbb4109656b89a51678220fd67e"
    sha256 cellar: :any_skip_relocation, catalina:       "d3f77d4f4b0f9899e74079753d754eb69296dfe5e44b6c2497c8680e0e941a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7bd4943c431bc7677d86bbc452a5582fa5a9d96486e089811738d52445e5b572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2080abdc26e68d518e2b989349107cbe479f9d10fe95f628851a0a638f43a5d4"
  end

  uses_from_macos "ncurses"

  def install
    inreplace "Makefile", "$(DESTDIR)/man", "$(DESTDIR)/share/man"
    bin.mkpath
    man1.mkpath
    man5.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    assert_match("GNU GENERAL PUBLIC LICENSE",
                 pipe_output("#{bin}/dhex -g 2>&1", "", 0))
  end
end
