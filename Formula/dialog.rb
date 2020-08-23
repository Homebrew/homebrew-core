class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20200327.tgz"
  sha256 "466163e8b97c2b7709d00389199add3156bd813f60ccb0335d0a30f2d4a17f99"
  license "LGPL-2.1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
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
