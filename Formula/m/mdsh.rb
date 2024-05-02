class Mdsh < Formula
  desc "Markdown shell pre-processor"
  homepage "https://zimbatm.github.io/mdsh/"
  url "https://github.com/zimbatm/mdsh/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "987fc01340b2d80029e7a1dca073cca4e7c8eb53a8eb980e8c2919833de63179"
  license "MIT"
  head "https://github.com/zimbatm/mdsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beff21a1ff152718c5782df119eda5dc9970a2b4a0344c0ae8bd077c5b8bfedb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "178f41349eee5fa384335142ecf509b12dbf252b33aa535a08cd544c0f8a06c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590c3ca3c20f28a54f5d55c3474970393f4472dfc8e101928dca3ebfae821e38"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ef56220a885441904e44fa9ce2b30152c033dbd4f077b1a607287d63bfc8407"
    sha256 cellar: :any_skip_relocation, ventura:        "71130fe8827f854a779706f84ae9ba725673ede641e9dae6655479e3b88db1b4"
    sha256 cellar: :any_skip_relocation, monterey:       "d3e8e14d72f25d9384912431efe83f6090424f420408a1982a90bf65e5baea29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5639229e187290b73532d3e257e1d86df8d85b870381c1e08ce81b970955a0d4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"README.md").write "`$ seq 4 | sort -r`"
    system bin/"mdsh"
    assert_equal <<~EOS.strip, (testpath/"README.md").read
      `$ seq 4 | sort -r`

      ```
      4
      3
      2
      1
      ```
    EOS

    assert_match version.to_s, shell_output("#{bin}/mdsh --version")
  end
end
