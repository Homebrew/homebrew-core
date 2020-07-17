class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.22.0.tar.gz"
  sha256 "07c621dffc4253805b54c1b93dfc94a4ace84cc3157311c5b99047623d637d7e"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe0f104deaa52d7ec13cf00a8154bb3e9cf9032441bda59c1b27a1c0bc310d76" => :catalina
    sha256 "fe0f104deaa52d7ec13cf00a8154bb3e9cf9032441bda59c1b27a1c0bc310d76" => :mojave
    sha256 "fe0f104deaa52d7ec13cf00a8154bb3e9cf9032441bda59c1b27a1c0bc310d76" => :high_sierra
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
