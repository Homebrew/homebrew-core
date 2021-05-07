class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.5.tar.gz"
  sha256 "bee5cddfbd5ec254d0d8ec5e045618829d775084d00b8bcf353418beeb31a439"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e05de8618d55fcca4734e2d04546493e395bf54f305f39f280221d72e723d114"
    sha256 cellar: :any_skip_relocation, big_sur:       "f06eec30f75bd80d412f66392648aa087abbe83df79ab71e0fc621ed3da92fe3"
    sha256 cellar: :any_skip_relocation, catalina:      "725fdc81fd6505d0a7daed64e59daa7346fc049d5628ec3ef0974fe365c9aa0d"
    sha256 cellar: :any_skip_relocation, mojave:        "f21f0e0cc53336aeb580e2031935d11c0ca8f716cfe81c26ac187cdbdca20176"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
