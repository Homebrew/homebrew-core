class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.de"
  url "https://github.com/lukas2511/dehydrated/archive/v0.4.0.tar.gz"
  sha256 "611da321330ffd43d1dc497990b486b2dec12c59149803ad7d156980c8527f48"

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
