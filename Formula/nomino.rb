class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.2.2.tar.gz"
  sha256 "d9c925a09e509c20f10aba6b8130412f6f6cf91cfa398933e432da2a6626b83e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "230f30bff155bb8d4d8696fc67f2bb5ab2669612214622b9b9ef19548a3b2624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "debc9347e26e32f96227f71b2379e576d51515b63dc0020bd1890c4d178701ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "565d6e8393273664dbaf36ad49d9376954d081e8d56e4feeea041dd909ead770"
    sha256 cellar: :any_skip_relocation, monterey:       "b84565e1060c964ab085242ed73bfaf1534c80c571d6e504c500c14adf92d23a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fc73e4690081a635905b8765408ff3fc2f3e028b324f15bdec334793d4f074c"
    sha256 cellar: :any_skip_relocation, catalina:       "16c673e69cc0d967c4bdf8874ac225af6aa015900746bf9f33c0ac184b0f3f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0f97f6502964f65800aa610d00b917f92f070e25c4a6efb65684620aba986f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end
