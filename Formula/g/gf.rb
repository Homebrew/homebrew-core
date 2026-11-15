class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "eab11107d1e4f3fbd0d8653c6e998182e99b2a3c42a4f4111c4d2362827a3af0"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "049464afad56fd974001e708e9973328c4c1b707d897828aa64a10bbb188870d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "049464afad56fd974001e708e9973328c4c1b707d897828aa64a10bbb188870d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "049464afad56fd974001e708e9973328c4c1b707d897828aa64a10bbb188870d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "019256d0615f76ff80b0272f44019aed473ec3e05912129f26bb26de41bd6c01"
    sha256 cellar: :any,                 x86_64_linux:      "409bd8d350edc7d61e47aac0f9c3d964ef3bb080d8a266676d821ed9da4dd09c"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "cmd/gf"
  end

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
