class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v2.7.0.tar.gz"
  sha256 "40563b7f2f837138b0eddb83cc53fda6ea8c730eedf8b982f7cfd1227643ba7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f27e199f6740cfd1539d7065730c7cd3c2d5f1b3280d59e79a21f9ec84a88c2b" => :mojave
    sha256 "099303a2875e0b5f767edaacf6d819595f5760741758434a62ad2a4437513de0" => :high_sierra
    sha256 "9c649b86821705cd55cf0a6f9ec32adff17c76b793ff4d35798febc706e66e42" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/go-acme/lego").install buildpath.children
    cd "src/github.com/go-acme/lego/cmd/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
