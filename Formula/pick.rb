class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v1.5.3/pick-1.5.3.tar.gz"
  sha256 "925f5736cdc44455305678030b190e7ee359bd710af4cfaf0388d6d27e21bc93"

  bottle do
    cellar :any_skip_relocation
    sha256 "77eacf48b9f317239e5d9fcfa62dbaf90fb11fbbf603d7b4652b456fe563bdde" => :sierra
    sha256 "af14394e7e4374fbdb960ce07e5128f669a09dd6ef325ea229d26d2e7e627715" => :el_capitan
    sha256 "75e6b3b7b4e85f81b8c5528c2cd78a36e4601b5932908b1ebdd522a934c3d6fc" => :yosemite
  end

  def install
    ENV["TERM"] = "xterm"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
