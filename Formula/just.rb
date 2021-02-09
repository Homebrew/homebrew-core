class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.4.tar.gz"
  sha256 "7aee472e4b70e62e89d7d5185493a3c680aeae4cc323c842e4c5b9b8af47040a"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b136aa2a953b88985016b0db6ca12afdf9f6beeea04ba1f62331416bd0aa526"
    sha256 cellar: :any_skip_relocation, big_sur:       "78f15ce05d070d3703a12700d6451a581c5f557e87431c08172d767556ce568c"
    sha256 cellar: :any_skip_relocation, catalina:      "b545b774d8b02c850f4ef476a4b0d0e14db13920765ec86c7778fea1affd1d84"
    sha256 cellar: :any_skip_relocation, mojave:        "2254dc738e8f62d5fe20467e2bbd93207ce2670628f644ed320b8640d59b51f0"
    sha256 cellar: :any_skip_relocation, high_sierra:   "40b53f4c712088b72fc5a44f1be1040f9a6223f2a66a5126bae20b30fc2edd57"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
