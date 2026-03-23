class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "2bfbe9836178eba793feb54db331653dc3c1def7d6e6b0078fa7eda8e425fb31"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d542a1cb66003a8c73263c4a770fd688572b58700902b517214be843a7ae1822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d542a1cb66003a8c73263c4a770fd688572b58700902b517214be843a7ae1822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d542a1cb66003a8c73263c4a770fd688572b58700902b517214be843a7ae1822"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bfa75af1b2b2e4a87ab744e4f06f7e9ce58bda94c7e131b88aab01d030943ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab4d4d1c5b21ac74e06530482c20c46391de49fa3733658586f827dc60daab29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11200ec6ecd192a0500412fad5a83bc461b0ae503099b13ad1c3c4c5ce5cdb68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
