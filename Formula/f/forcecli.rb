class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "28660ce4997b717dd5e128372eba86f5fef5887d6b46dae60e4a50c27759429b"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b83b2d77bd10097ac365dfcc40cdd07cccb9146de0efc07e28895fdd703153c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22312351186287c0b9726d9e8df9aa11d1959d431116c7f2f441a413072b5143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f434044ad70f66a004ad11fa40f80a9ee55e60cc012f89366bcdecb03126e98c"
    sha256 cellar: :any_skip_relocation, sonoma:         "316bc898751c7bd4a44179c4e506740764d2422081dff458f4bf79857700e895"
    sha256 cellar: :any_skip_relocation, ventura:        "1d833e10184ea4feb0a90e75947149effd01dbcc7e8bc878aa94ad22be51ea36"
    sha256 cellar: :any_skip_relocation, monterey:       "076ea667872f5149b34617ed4061653e2d94818ccc2d7e0026e93e8d88746ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d6c34c0c741b578ebd6831693eb82f5f7fcc02af1000a27ffd420fc6158caa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
