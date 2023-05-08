class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.8.1.tar.gz"
  sha256 "06650d5a21b1cb3eabae05d129ceaaaecd9eb7788edfbd3e63947e83279ca9c3"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a0b49998413b50448103a8050c0262959de351051b59c039baf057c17dae84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e002231d6b75217a329ef85d726221ed3bfd5a2a9c2ed5d954126182f9365568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d4de3fbfbee50c5b576a7fdf45eb5e473cc71f520e541cbc9d27ea5e531727f"
    sha256 cellar: :any_skip_relocation, ventura:        "9465d4deea0f94e9f07c6b4beb4f2080ad4dbcafe8b9f86511e2a4b6c6f5a64d"
    sha256 cellar: :any_skip_relocation, monterey:       "1444c4773770aafa9c7c9fd2a2850a8ad0037c9f9299cc3bb8168bcdfbc1c6ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a4a855e6a667b59c2b6c4771178d1c54c8ae2a479cd1a5213dc87d6d17a903e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2148f5284b51f75d69ed137719646c2c2df209ae17aee983eef378f337792f6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
