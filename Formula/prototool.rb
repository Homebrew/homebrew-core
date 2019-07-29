class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.8.1.tar.gz"
  sha256 "a8d402afeab2d9030378bafb9f913820654aebcbd0c35010c8a23e6b43268b0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5501cc96c9d975db2938480667af657c524607f308208c9a2497c2774f134c2" => :mojave
    sha256 "18f25387e8188b628af0a09827b53c1672c6850011fac6ae3e8e942644c32f99" => :high_sierra
    sha256 "e66fd774e3095f7f4116b546cc94aa3b6ae1aaef31255c966daefd2f3cdb2ae9" => :sierra
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
