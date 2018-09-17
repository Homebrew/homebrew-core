class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.3.0.tar.gz"
  sha256 "727c64ce45e2f07445838677bd08009f7975d70648d327008ec5369631266493"

  bottle do
    cellar :any_skip_relocation
    sha256 "b596a61d1a00123c749d473b87460d2dc84123c1b6b2a25307b5a3557232da0e" => :mojave
    sha256 "d0c768377d7336ace520a3476ec40740a21249b46b600d44c6ef95b23d6dfed0" => :high_sierra
    sha256 "b2781bc1baccfb8957ecfd2db0c1a67d337dcb6eb123f7cd681ec74bb3157b0f" => :sierra
    sha256 "b159f5c718bea7a8dae0c5a920ceb9e3de783e7bad8bed4c1898eff874003321" => :el_capitan
  end

  depends_on "glide" => :build
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
