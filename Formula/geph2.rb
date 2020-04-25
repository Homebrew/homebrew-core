class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.21.4.tar.gz"
  sha256 "4a815ff800c492e2d7b7b5fa0dabeffc14d7c33307c0a00c4e533ec4ce85ff29"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1540b9ee25427d5dbf4514e816771991e2e3310dcdb5ff08b1ec7f63b678cfb" => :catalina
    sha256 "e1540b9ee25427d5dbf4514e816771991e2e3310dcdb5ff08b1ec7f63b678cfb" => :mojave
    sha256 "e1540b9ee25427d5dbf4514e816771991e2e3310dcdb5ff08b1ec7f63b678cfb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    bin_path = buildpath/"src/github.com/geph-official/geph2"
    bin_path.install Dir["*"]
    cd bin_path/"cmd/geph-client" do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-o",
       bin/"geph-client", "-v", "-trimpath"
    end
  end

  test do
    assert_match "-username", shell_output("#{bin}/geph-client -h 2>&1", 2)
  end
end
