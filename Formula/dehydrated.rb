class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.de"
  url "https://github.com/lukas2511/dehydrated/archive/v0.5.0.tar.gz"
  sha256 "3559de9c61f8cb9dda1d247fbb88d94eddcf2d9421941dad73b1d672cb933abe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7d80caaed26d1f6adcdfc0b403f00efce945860b1e6699432891f752355492ca" => :high_sierra
    sha256 "7d80caaed26d1f6adcdfc0b403f00efce945860b1e6699432891f752355492ca" => :sierra
    sha256 "7d80caaed26d1f6adcdfc0b403f00efce945860b1e6699432891f752355492ca" => :el_capitan
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/lukas2511/dehydrated").install buildpath.children
    cd "src/github.com/lukas2511/dehydrated" do
      bin.install "dehydrated"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
