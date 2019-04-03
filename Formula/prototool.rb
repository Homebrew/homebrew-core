class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.5.0.tar.gz"
  sha256 "e83c6cfabaa12d8a876a32ebdf94fadc9ffd8e04d512e539f54effab29fa2831"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dd27760fb37b89ac3b033ce0afeb94ce1c8684db73bfb2ca9bb061933b0212a" => :mojave
    sha256 "6837218b824961a5c230afc8c4fc9b9130503cc0e94ee635920167098f33eb51" => :high_sierra
    sha256 "5ede7a46469b9c15976cdcdb66ce5bec04a7294a3544429cab7b30cb07d7c136" => :sierra
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
