class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/2.1.0.tar.gz"
  sha256 "a1ea624e913e258596ea6340c8818a90c21962b0a75cf005e49a0f72f2077b2e"
  head "https://github.com/prasmussen/gdrive.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "be226948f3fe5607a3411403a2ed641edcb7cce170d3ae02720c7dc58313e941" => :mojave
    sha256 "f0971622df162e07eadb14f3aa2947edb088c05791fc2931d6cc3ee93e6bd9a3" => :high_sierra
    sha256 "49e6aafb46c7267d013c4c45edaf24da14b184e53e841ebb825a87f545ce13b9" => :sierra
    sha256 "fd217d3f50e967972eccef6b4d0fd537b9f7c0c0b230fa83ff6ac9ee94a77ea5" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prasmussen/"
    ln_sf buildpath, buildpath/"src/github.com/prasmussen/gdrive"
    system "go", "build", "-o", "gdrive", "."
    bin.install "gdrive"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
  end
end
