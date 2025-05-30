class Cvsutils < Formula
  desc "CVS utilities for use in working directories"
  homepage "https://www.red-bean.com/cvsutils/"
  url "https://www.red-bean.com/cvsutils/releases/cvsutils-0.2.6.tar.gz"
  sha256 "174bb632c4ed812a57225a73ecab5293fcbab0368c454d113bf3c039722695bb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.red-bean.com/cvsutils/releases/"
    regex(/href=.*?cvsutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9efd138b85d862065f5a5d36e02a4ec04c40b6f669bfe7feb09a08f233991d50"
  end

  uses_from_macos "perl"

  def install
    ENV["CONFIG_SHELL"] = "/bin/bash" # for all bottle
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"cvsu", "--help"
  end
end
