class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.6.0.tar.gz"
  sha256 "47374f818244d6fe8679c3d9a15ee7933a996b245e1c5431071c58d7cb01694a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5eaa0eb6f0121f409af1612362c055aa798ce10bf316b22bca0f35f21cdf38ef" => :mojave
    sha256 "b58b0581fdefb0f92eec86474693891988b301669cb5e2090a8baecb396ec0cf" => :high_sierra
    sha256 "6639f60c9a848f642f85b16955333e68594309e6e5af11b500760f7b27e7f8e3" => :sierra
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
