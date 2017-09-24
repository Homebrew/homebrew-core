class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/2.13.0.tar.gz"
  sha256 "e95452b93b94f7f39b82064dcf21c77ceecd6ccc1e18d282eb43bb2b188f0943"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69e5ff29262f57a81b99df284241efe75f369e69e715c3e4f0a161c7cb97729d" => :high_sierra
    sha256 "714ceeb5b1c52ef320a6f61c169f8aa9daa92f032cd8bfa89c0fb061983241e5" => :sierra
    sha256 "71c0270a2794beb8e2069b6614dc350a1a0e3169d60cecff74fd2967c2df82e9" => :el_capitan
    sha256 "c6088a39b15de6e93a16202ae141651f245643572c6bd010d4dfe177853234a1" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
