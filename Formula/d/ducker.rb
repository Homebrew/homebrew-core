class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "8a194a077ad6c278f3b5a3157fdf70285d517c5a9b76d09740cbd56ae685b1c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a084efb351dc275a0451a0d3cebf8c8b232d29e82892eb248ffadfb642b318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "641bae2181d618051a983cf8bd891b6293b2cf7c4f8a2fcd95fde6a07e5f2375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c38cd0f5c02d0df00fe2c6a9682af7c60a2aa49fbe2f9e5045e8b01f0cc641ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad2e836505663c917060b08cd244720459f70290a4aab0e4d2a832d2a3c0090b"
    sha256 cellar: :any_skip_relocation, ventura:       "31970d3d323e8ff6bc49d2a6f359693958ae6461bcec3ed9a55ddf8bfc5f8a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d68dab3a1f328cb6060709b9b82674d6c6e69a9e597f3563875916fc935c4957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67f68fd898023c6f6b29c4404e07be98806f073862a2e005c2174d4c34175a8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
