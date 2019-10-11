class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/gdrive-org/gdrive"
  url "https://github.com/gdrive-org/gdrive/archive/2.1.0.tar.gz"
  sha256 "a1ea624e913e258596ea6340c8818a90c21962b0a75cf005e49a0f72f2077b2e"
  head "https://github.com/gdrive-org/gdrive.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "c89785f7d95e16fe113f649f47c80261ce7d335427d60c6543a3bd8d58eee522" => :catalina
    sha256 "e26ef4bec660913f42aa735c28f58393912d2d0293bf98a351fa2b27a1baee01" => :mojave
    sha256 "8fc5917762cd0b7622d35053931b41315606be97ba38ae34c9a67bf7ff87a1d3" => :high_sierra
    sha256 "b03e82ba9bb723b7f6225607b3127b9d515f0d79271f76b375b74324aecfb057" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/prasmussen/gdrive"
    dir.install buildpath.children
    dir.cd do
      system "go", "build", "-o", bin/"gdrive", "."
      doc.install "README.md"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
  end
end
