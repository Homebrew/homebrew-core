class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f22567f902c464080951f0a9e3e1fe758b81e9ac3a71be31296f0af32e9aece9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b74cb13657af152c2124a88e1786898fb2ccee8679247438d77413a3675c71e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74cb13657af152c2124a88e1786898fb2ccee8679247438d77413a3675c71e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74cb13657af152c2124a88e1786898fb2ccee8679247438d77413a3675c71e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fadadfb9732e9fc0a8d534309ff007ac69bce8fee2acfe2208aeb6196a8ffd13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e86ac4e58cf868455b9553ae098c1cf4020a72211c2fca14cd7e57bb71680e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fdd3f0cb6c5377ae7eebd5deaad43a0970a4320ef4391c9e7219c43f127bd03"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/qo"
  end

  test do
    input = <<~CSV
      id,name,age,city
      1,Alice,30,Tokyo
      2,Bob,25,Osaka
      3,Carol,35,Kyoto
    CSV
    sql = "SELECT name FROM tmp WHERE city = 'Tokyo'"
    assert_match '"name": "Alice"', pipe_output("#{bin}/qo -i csv -q \"#{sql}\"", input)
  end
end
