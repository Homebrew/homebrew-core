class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20201126.tgz"
  sha256 "c9233a6c8ea33a59e2378e5146ae2bd13b519744cfdb647af7420adac5ad3866"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9f372d53ff05a0d9a640d7f019797eec80ecbe03a183f8c480ba5f3fdc63b88c" => :big_sur
    sha256 "35e1f4c9beb789e9f6db97089f5c0d41032cf72f79ebf2aa1fd804d6d5d62240" => :catalina
    sha256 "2de067bc267ae01c09b826e55a2ab8626fb9f04e15aeb30189653c731db890db" => :mojave
    sha256 "0e979958393b4d5db87aea2408ed1ac385db8b999ee38b882da96ed0e32beb19" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
