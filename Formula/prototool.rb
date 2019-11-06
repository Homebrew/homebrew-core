class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.9.0.tar.gz"
  sha256 "5f549c2c0c36f938b7d38d1fdec1deeb891ea10d534ee0e6a56ee7f9f746e89c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f2bfe70e42f7ae8fb136a7a17ec0138240f23eb15eba1f150971f867bef097b" => :catalina
    sha256 "796c219902fcc8201d41c183efb470e97ef0251b70759826c4ef08dc06edd991" => :mojave
    sha256 "d6fb6d50f3ac98e96a39c2425196f043f995ddc2368be51d6ea3d4345cd29363" => :high_sierra
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
