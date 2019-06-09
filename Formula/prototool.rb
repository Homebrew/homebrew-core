class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.8.0.tar.gz"
  sha256 "4a25ecd22e1d6234ad07e5b07923e5b65327cd11ea4a44f2163d2ac2392ed20e"

  bottle do
    cellar :any_skip_relocation
    sha256 "23b854b6cfca6861ec7ecaffb2f139955f6e26d4f0e017f4c95ea8be43a3530f" => :mojave
    sha256 "5cdf73fb1d93146474a4b6b4c6355a982c9bfb37e60cc2bf3e1e3751830c4947" => :high_sierra
    sha256 "ba508b667a020c183e8bb3e0225bd70e2d4a8af52b5633725e8ebad8c9e28e12" => :sierra
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
