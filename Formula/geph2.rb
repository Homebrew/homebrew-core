class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.22.3.tar.gz"
  sha256 "1a0aeb6722c79460070db86319fab1ae3d9eec90618a3b6960faacc88731d98a"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bb066d5037011005e96467b055349395684098af46b9e8bbafa6d6ca23f28f3" => :catalina
    sha256 "8be3fa40789dc634416626db3aaf4c7457da63178ee04005edd2d5b807c92553" => :mojave
    sha256 "2632e8c16a9df74e0278db220961e15e9ff3bb421a15db944c8aa801e7125626" => :high_sierra
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
