class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/v0.2.1.tar.gz"
  sha256 "3be0198f358d49aa9b17fd8622ab5d4e3732dc45226fe1804f245a0773504aee"
  head "https://github.com/cbednarski/hostess.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9ffe341e6687727515fb5c0375c0998304d048b9cb96295965f43fa02610b53" => :sierra
    sha256 "ff21d6521c49265d610da56697a549082a31839cf9561dd3c7c4a110ef4bffce" => :el_capitan
    sha256 "7fd25d03ed51a7d0b4e62255ea589398a356464e6d62a8093785c4fca3c2769d" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/cbednarski/hostess"
    dir.install buildpath.children

    cd dir/"cmd/hostess" do
      system "go", "install"
    end
    bin.install "bin/hostess"
  end

  test do
    system bin/"hostess", "--help"
  end
end
