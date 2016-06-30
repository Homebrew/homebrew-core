require "language/go"

class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats."
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo/archive/v1.1.0.tar.gz"
  sha256 "1ca8ee1130d57fb70b1c21cc9311d8b036b86d456eb88888d603e88fbb1d056a"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    mkdir_p buildpath/"src/github.com/square/"
    ln_s buildpath, buildpath/"src/github.com/square/certigo"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "certigo"

    bin.install "certigo"
  end

  test do
    system "#{bin}/certigo", "help"
  end
end
