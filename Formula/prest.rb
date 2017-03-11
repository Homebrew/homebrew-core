class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/archive/v0.1.4.tar.gz"
  sha256 "8d1a38e1ea45ebf7bffb34258ba2db5c404a58139597b6a8439bcaaeec12084e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c4474e7206664860b17f986817ed9aa324b1b4e6e094abc85448484bfc9f914" => :sierra
    sha256 "3acbd0dd871e970bea6141f9a2574caf24e9796a79095f2d9fa2eaecb2d5abe0" => :el_capitan
    sha256 "6d439c7945a7d108a3fb0675d6a20cf9dd3965fe7d7db5a2e741a3b4312a4f66" => :yosemite
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
