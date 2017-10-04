class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.de"
  url "https://github.com/lukas2511/dehydrated/archive/v0.4.0.tar.gz"
  sha256 "611da321330ffd43d1dc497990b486b2dec12c59149803ad7d156980c8527f48"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d92386164f377135a09a716d28d35edb72e288d161d14b6e750fa81a1cd5e86" => :high_sierra
    sha256 "1e10f18db5678d8e22b0b08766d9f4f94ee86ad56111555fe8e715f8de4c00c4" => :sierra
    sha256 "1e10f18db5678d8e22b0b08766d9f4f94ee86ad56111555fe8e715f8de4c00c4" => :el_capitan
    sha256 "1e10f18db5678d8e22b0b08766d9f4f94ee86ad56111555fe8e715f8de4c00c4" => :yosemite
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
