class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v0.3.0.tar.gz"
  sha256 "a8fef456abc47a34aedb05d95c4b9a64d2f7f306016cb789f2b0de9229f5d3f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "798f4a38ff9c561b29b5b7db938ceafc9bc720c94f9f332657d1f2c64ff813ab" => :high_sierra
    sha256 "77f47a1cc27feb1b923d617fccc750d252661655d15582135a49e2b975baadb4" => :sierra
    sha256 "8fa3ca1a6776a29c4c9e96d815e05e3aa20182844f9b9bde3b96e04ed12d4d99" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prest/prest").install buildpath.children
    cd "src/github.com/prest/prest" do
      system "go", "build", "-o", bin/"prest"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/prest", "version"
  end
end
