class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.7.0.tar.gz"
  sha256 "e7a87c6f4387824d3a3b6d444e1fe0b85e418a07feaf34df9cae9ef5d554c5e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bc1c30bd135e81727a5d5100642b9058249df8ee769f03c9b73b9606102fddf" => :mojave
    sha256 "a9abc015d833eb5e37e8c34e8d319d1c937bec4ccd48b1d1eae2217a26596f35" => :high_sierra
    sha256 "55ff608e70bab8fd4e185c2219aa9e8737475b10462fbe76275856272379d84f" => :sierra
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
