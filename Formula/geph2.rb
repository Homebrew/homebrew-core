class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.22.3.tar.gz"
  sha256 "1a0aeb6722c79460070db86319fab1ae3d9eec90618a3b6960faacc88731d98a"
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
