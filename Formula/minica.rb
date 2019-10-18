class Minica < Formula
  desc "Small, simple certificate authority"
  homepage "https://github.com/jsha/minica"
  url "https://github.com/jsha/minica/archive/v1.0.1.tar.gz"
  sha256 "d5fd5259642dcd8ff98cb81deb4c66424a97c7bee2670622a6a057a6de5cfd03"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e6c8aee5224159bf91d3c48e7cabdfdb1ad07dda5a08a8e46a06b3b6985fd9e" => :catalina
    sha256 "b9e770340412c61c71cee5c4428fb43bc3204615c826f3a2daabca42869cea66" => :mojave
    sha256 "52bcdc795e10b9fffd91984fc50a17c68c658f409ff545c6d94e147f2adce66a" => :high_sierra
    sha256 "de8de2c3f4a630f159186701abd9badd6d8f086fabc47984af857d809c28e822" => :sierra
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
