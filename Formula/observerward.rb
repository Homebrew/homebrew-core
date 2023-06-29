class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.6.20.tar.gz"
  sha256 "3d14e27ad75980f2637e9e7ddebc3563e2fc400a56c5514e8971b4b1ee4ff75f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98f809f325d481065926b8dd369f651cfa8a3a01c034f5e85352cd5b77cf46cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2df7cc4f92ddfbeb6ba47909752daf0262d5ef8e745aa906cc93380440ac433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4297e021396eb5ccd13e1fac3dd2002baee6cd8811b52586a179ed0442623d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "db6e9f4af17f1633b6c7f5c13b56910975d4be66ce3bce648e8376bb5c2bc9d4"
    sha256 cellar: :any_skip_relocation, monterey:       "89d692acfa72d72ac21f767a28a6b7f9d112f1e0d600b0bf0906ac45fbdba97e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0539a6f5cccf51843714c83e7c1d1681614be11a5cd138f30080eea376fd0a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1d8f2a668d69870b58cdb016513aaf52a60bc6d1a96009f876f911ae50e763"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
