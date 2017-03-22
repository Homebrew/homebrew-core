class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/archive/v0.1.6.tar.gz"
  sha256 "28171f221c86ec01027b858f9070ebfdb0e766baa09bc48f597dc28b34b7c722"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e60169a9d5672485066e5dad81a93c1f3d87f4b71beb7499d8582fad8cfd593" => :sierra
    sha256 "1e79b9bb4d3926186480a501b590d44c636eeac615d1dba0506f78d6f8640084" => :el_capitan
    sha256 "bb0d28d02e6a5c1d6b1addf7e25c2d78ff368dc4f6c4f4bf9237176dd9b0d01f" => :yosemite
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
