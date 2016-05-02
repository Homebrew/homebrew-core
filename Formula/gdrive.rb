class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/2.1.0.tar.gz"
  sha256 "a1ea624e913e258596ea6340c8818a90c21962b0a75cf005e49a0f72f2077b2e"
  head "https://github.com/prasmussen/gdrive.git"

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
