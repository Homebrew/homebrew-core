class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/archive/v0.1.4.tar.gz"
  sha256 "8d1a38e1ea45ebf7bffb34258ba2db5c404a58139597b6a8439bcaaeec12084e"

  depends_on 'go' => :build

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
