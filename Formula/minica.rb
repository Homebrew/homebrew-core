class Minica < Formula
  desc "Small, simple certificate authority"
  homepage "https://github.com/jsha/minica"
  url "https://github.com/jsha/minica/archive/v1.0.1.tar.gz"
  sha256 "d5fd5259642dcd8ff98cb81deb4c66424a97c7bee2670622a6a057a6de5cfd03"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a48ae026334e8e8bf0e7de08e24479ba69dd0bbd51cb20df6e1a3cee8087bdc" => :mojave
    sha256 "0adf118d5b59116c39241ae2c96ffec88ffae1d2733de216db1429c4fe203091" => :high_sierra
    sha256 "4f308229516b4a6958f8b34f00f9032d0100af23ad5a0c2798984580467847fc" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jsha").mkpath
    ln_s buildpath, buildpath/"src/github.com/jsha/minica"
    system "go", "build", "-o", bin/"minica", "github.com/jsha/minica"
  end

  test do
    system "#{bin}/minica", "--domains", "foo.com"
    assert_predicate testpath/"minica.pem", :exist?
  end
end
