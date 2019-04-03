class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.5.0.tar.gz"
  sha256 "e83c6cfabaa12d8a876a32ebdf94fadc9ffd8e04d512e539f54effab29fa2831"

  bottle do
    cellar :any_skip_relocation
    sha256 "47dd93af5f7bc9e93b2c3299e28fb909fd25c5dadc346e70bfb49b1e5c17e633" => :mojave
    sha256 "9cab082b0b1b5aa726e6500d691cee0c43bf89fd635cc64ced144eb68cbd3a5b" => :high_sierra
    sha256 "f1239132180c58420e7332f3021cd57a7420315dd2e6a73b2eb39ff10a2e3169" => :sierra
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
