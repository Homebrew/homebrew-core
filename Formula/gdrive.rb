class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/2.1.0.tar.gz"
  sha256 "a1ea624e913e258596ea6340c8818a90c21962b0a75cf005e49a0f72f2077b2e"
  head "https://github.com/prasmussen/gdrive.git"

  bottle do
    rebuild 1
    sha256 "63c7bdfe51154a2b4748f8b157a709a7f2e1eea8b04623b9210ea5b2e0765e2b" => :sierra
    sha256 "87c24360f961397b3e839d1fd8c63b6b48af69b3284aab1781f374ac7cfeefa7" => :el_capitan
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
