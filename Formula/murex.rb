class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.3.4000.tar.gz"
  sha256 "d96bad1e575556d710693ace4286c9a5ec840046b6aa2c20e3e2369b6be1711a"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cb1643c2f5392de0519bac2af3ea76b618d7d61429232d12dcd0ab2ea5a0fa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f73b657d524a20903c41698de8c540e99d67d15ac1e3fe0949bf2a95a0053834"
    sha256 cellar: :any_skip_relocation, monterey:       "db81f12d12e8fc403eb2d7c15b272b25770af43eff88e5948e8b3c7f612eac37"
    sha256 cellar: :any_skip_relocation, big_sur:        "12eefd6b9c97355f859e324a9c4529665728d1c9ab1d37d6751b08de5b403b36"
    sha256 cellar: :any_skip_relocation, catalina:       "9581c91714fd365ccadef6c684ec325a7eb28e245eb593ad8d1447b122a782c0"
    sha256 cellar: :any_skip_relocation, mojave:         "679539415a2932209e263bd6182f385b0008f1315cab111583f54de7aa9ca736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e35e671757d01e907360a88dba39df2c904e649a9d8d8ec0da2b43fe639d28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
