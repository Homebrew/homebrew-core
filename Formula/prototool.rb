class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.2.0.tar.gz"
  sha256 "16654242f1f22eaeb2df0c33366ef7a22fda674b51bd4c8da38e0ffab62ce236"

  bottle do
    cellar :any_skip_relocation
    sha256 "9267ebafbf8b194ba5800e6211f61432abd0a25f04fe245a504141d14170850e" => :mojave
    sha256 "2ea17c28849ebb1212f3a2c4d63ca9adffa1147781f7f43f9aaefa18124ff431" => :high_sierra
    sha256 "aa4f8820b92a22358fff4b0f35a10fdd5b2a56a7dad9def55fc51b84d847c509" => :sierra
    sha256 "38ca6e71116f21fba39601114cdba08c24b7a8455246c748847e9abbf28ef6b3" => :el_capitan
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
