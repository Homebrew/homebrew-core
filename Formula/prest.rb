class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/archive/v0.1.6.tar.gz"
  sha256 "28171f221c86ec01027b858f9070ebfdb0e766baa09bc48f597dc28b34b7c722"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa5fda665a4877e897d3c2c559a1e40d7360c9ec5eb7a741c90e71643a5a77b5" => :sierra
    sha256 "54bd8ec3eb1b84ec0493319671e8424726ea1a6172db917a5248c14eec9bf97c" => :el_capitan
    sha256 "bbb7035fd26519df79a9883151f9bf53218ae8965f7e81a75c4022c8a9d577a1" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/nuveo").mkpath
    ln_s buildpath, buildpath/"src/github.com/nuveo/prest"
    system "go", "build", "-o", bin/"prest"
  end

  test do
    system "#{bin}/prest", "version"
  end
end
