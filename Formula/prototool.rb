class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.8.1.tar.gz"
  sha256 "a8d402afeab2d9030378bafb9f913820654aebcbd0c35010c8a23e6b43268b0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9de2c01d1f99a96c389c1700b65c3163301b54fe694b70a47aa5c5d055a5b5c3" => :mojave
    sha256 "7dfc29e85c46ce1e6e1e471eb83427bf94130589e3f2c21cc1845048a03415a9" => :high_sierra
    sha256 "cc4cceb298d76a8d589a141f3a25582d69a8e2357d52b53a19822a8d052b6cf0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/uber/prototool"
    dir.install buildpath.children
    cd dir do
      system "make", "brewgen"
      cd "brew" do
        bin.install "bin/prototool"
        bash_completion.install "etc/bash_completion.d/prototool"
        zsh_completion.install "etc/zsh/site-functions/_prototool"
        man1.install Dir["share/man/man1/*.1"]
        prefix.install_metafiles
      end
    end
  end

  test do
    system bin/"prototool", "config", "init"
    assert_predicate testpath/"prototool.yaml", :exist?
  end
end
