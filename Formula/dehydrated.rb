class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.de"
  url "https://github.com/lukas2511/dehydrated/archive/v0.6.0.tar.gz"
  sha256 "2285a0691c13ec39b513ed5a2d49c4771d0bc0580a70ea585f06a35526123dbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "3405d46444ee47e705f48c38bc046a4af85afd14959eefd7b3edcefa71a0de25" => :high_sierra
    sha256 "3405d46444ee47e705f48c38bc046a4af85afd14959eefd7b3edcefa71a0de25" => :sierra
    sha256 "3405d46444ee47e705f48c38bc046a4af85afd14959eefd7b3edcefa71a0de25" => :el_capitan
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
