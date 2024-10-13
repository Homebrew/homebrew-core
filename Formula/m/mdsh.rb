class Mdsh < Formula
  desc "Markdown shell pre-processor"
  homepage "https://zimbatm.github.io/mdsh/"
  url "https://github.com/zimbatm/mdsh/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6d87498bf600ef3b0d5ac8813e676ee1e7913057cf9290a288b4d93c7ffcc4e9"
  license "MIT"
  head "https://github.com/zimbatm/mdsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5bef5cf5387264ba779d84ad53391a311573cd9a59cbc678b6a0fab6c4219f00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cb6ad949b1853f9d378b1677bafe46d2eefdce5fa236789ba20b41f86a9d6ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd1175a75d3a77ae26605493aeac7473025081b7b962c3c1b9c9a587e6b3100a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f59e1fed6183d5910b70de5cb5aa1b6663456cdbbed62f160fac931944d6cbd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f514330a4e5407ea8ed0087f32bbc1c8b32e908b71663852768d54e47d21e1b"
    sha256 cellar: :any_skip_relocation, ventura:        "e21b5ebc1a866e457fedeba187f68e9ab7dcce67b71f51e60e05a17720f1b5f8"
    sha256 cellar: :any_skip_relocation, monterey:       "36730e48b121e9a0357c215021eb2db025849ad2dc8eda3469084cb5b25ed085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417d4e50323892d738d5634208d579873994f28ea7fd0110b6035ca50abe48fb"
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
