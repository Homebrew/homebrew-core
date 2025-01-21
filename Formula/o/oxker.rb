class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5e178f33c036d63512d2b619968c7095d2c4f0176c7789107cf57fe48b04e070"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "683f8e0fbc4d3d3b89cbf0f3d54df8685e4e486c903a92c3cf99b0138b0d996c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2109564b163e791844314820916d2b68aa28ef2dcf6d9ba2c7dfcc947dc3e81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2da1975aada0481f3e8e1f809bd5a8ec2420b618b4d1796ae57fc8250139b386"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3592d67379713e450f964b3c32597a132242001cfb7d3eda324d3e3f7f84f5b"
    sha256 cellar: :any_skip_relocation, ventura:       "aae8558fb3a2f9cc2f5065ac3b94354ed3de684717f317563886f2c44f0283ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0212a249667c32456212d9336fc561290776480f83f2a525883292b327687ae1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
