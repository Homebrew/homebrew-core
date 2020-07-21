class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.22.2.tar.gz"
  sha256 "dd1ccd9c5aac06b46d57b9ba7aab00b6f42b3ec8fde85d00f09e2e474e7c1dc1"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "17e96110a9640a444117efe01baae83a724d21508d6d8462e983019eeeba0f2c" => :catalina
    sha256 "08c896df1e47ab01f442662752031a10a73f6aba82c7e3ed0528b4b7561db2ab" => :mojave
    sha256 "08c896df1e47ab01f442662752031a10a73f6aba82c7e3ed0528b4b7561db2ab" => :high_sierra
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
