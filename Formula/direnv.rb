class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.12.2.tar.gz"
  sha256 "108adad7859935404c9fbb66398bee768a5eb9bb95bfe4048b5e6cb03f7b790e"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "714ceeb5b1c52ef320a6f61c169f8aa9daa92f032cd8bfa89c0fb061983241e5" => :sierra
    sha256 "71c0270a2794beb8e2069b6614dc350a1a0e3169d60cecff74fd2967c2df82e9" => :el_capitan
    sha256 "c6088a39b15de6e93a16202ae141651f245643572c6bd010d4dfe177853234a1" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv").mkpath
    ln_s buildpath, buildpath/"src/github.com/direnv/direnv"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
