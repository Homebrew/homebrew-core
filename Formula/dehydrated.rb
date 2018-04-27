class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.de"
  url "https://github.com/lukas2511/dehydrated/archive/v0.6.2.tar.gz"
  sha256 "163384479199f06f59382ceb6291a299567a2f4f0b963b9b61f2db65a407e80e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab3660f18631f6534ed6e19def414775f04ee7b90a003fd700ab2b80d1434f68" => :high_sierra
    sha256 "ab3660f18631f6534ed6e19def414775f04ee7b90a003fd700ab2b80d1434f68" => :sierra
    sha256 "ab3660f18631f6534ed6e19def414775f04ee7b90a003fd700ab2b80d1434f68" => :el_capitan
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
