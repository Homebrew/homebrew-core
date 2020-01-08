class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v3.0.1/pick-3.0.1.tar.gz"
  sha256 "668c863751f94ad90e295cf861a80b4d94975e06645f401d7f82525e607c0266"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f5c3b2a34966596f3e5ddf33de5524f656aa558a00fcd6ef47c262115a872d6" => :catalina
    sha256 "4f376e252f19746091a38cc04c25ba95b69b91855e9655e91ddff1e79cc3b6f4" => :mojave
    sha256 "596b06179a358b1be315dedaef900d28c059ef710c428ecbbbb5072c2294380e" => :high_sierra
    sha256 "e91e7c5882344a8d2722c50bad65959aacfdef739206aec833722b6f00a2e8a2" => :sierra
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    system "./configure"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
