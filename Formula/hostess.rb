class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/v0.2.1.tar.gz"
  sha256 "3be0198f358d49aa9b17fd8622ab5d4e3732dc45226fe1804f245a0773504aee"
  head "https://github.com/cbednarski/hostess.git"

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
