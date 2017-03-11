class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/archive/v0.1.3.tar.gz"
  sha256 "ddb7485d8e6395438d645c93a557fb981b1581ad93f97545ccd411dbf2ae3cc1"

  depends_on 'go'
  bottle :unneeded

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/nuveo").mkpath
    ln_s buildpath, buildpath/"src/github.com/nuveo/prest"
    system "go", "build", "-o", "prest"
    bin.install "prest"
  end

  test do
    system "#{bin}/prest", "--help"
  end
end
