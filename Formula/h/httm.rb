class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.2.tar.gz"
  sha256 "0c722977e4e4dd3080544735cf629d077437d88c99b6c3a806e9bbd5f7dbecb5"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05fdfc68342b97d5ac21482fd8308941a89ab504dca90056f74ca51cc97470c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b152e69a659a53acb37c4f61b5007eea468b6375b17cd9dfcecbede7934b4fdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0662f12f9e49f4e6ff110ba5ab5215020cbf63461f3f8365d21ef65939742a60"
    sha256 cellar: :any_skip_relocation, sonoma:         "920a0c4b8593fdd960fe2d4ca26538bf23768907468e1ada096682f806bf4927"
    sha256 cellar: :any_skip_relocation, ventura:        "a305af5edd1290910422644435ebdb28148dc0967fe6b0e6b73888fd4537d2ea"
    sha256 cellar: :any_skip_relocation, monterey:       "e1790bf9822991e1d70f38c842c1df6d8d139495b98fb5e2170a4985df991d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057169a8791f26ea278efce4e65762284c4adbc8a1eb4f98ec606fd1ca9bee61"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
