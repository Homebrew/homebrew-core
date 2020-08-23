class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.22.2.tar.gz"
  sha256 "dd1ccd9c5aac06b46d57b9ba7aab00b6f42b3ec8fde85d00f09e2e474e7c1dc1"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a596d4f5c73bdaf166874f9ad4c8721d8ccbbe39da45541b00293a4b55675d1" => :catalina
    sha256 "6a596d4f5c73bdaf166874f9ad4c8721d8ccbbe39da45541b00293a4b55675d1" => :mojave
    sha256 "6a596d4f5c73bdaf166874f9ad4c8721d8ccbbe39da45541b00293a4b55675d1" => :high_sierra
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
    assert_match "username = homebrew", shell_output("#{bin}/geph-client -username homebrew -dumpflags")
  end
end
