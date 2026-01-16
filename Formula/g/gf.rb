class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.9.7.tar.gz"
  sha256 "9e509ef355c3bc80ae5f200bacaccf9d9b61fbc814dc1f64e38dd992dab0162a"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0b5ed20de04946ba0f43a2998bb451509eae95b1b961175928a01e908136cf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0b5ed20de04946ba0f43a2998bb451509eae95b1b961175928a01e908136cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0b5ed20de04946ba0f43a2998bb451509eae95b1b961175928a01e908136cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "326105b7b8726b47e2a3bba7c19da5f1da8bf49c87a1c59516ae20e9d3a25616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "383e08928d79012fff369cac70c0de33ce484779fa6f82bf50921f03594696a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca8b5b205454365251c46240aea7704d6d26afb58c93edaad44dde24774b0d1"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
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
