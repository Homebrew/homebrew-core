class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "548e000382e013d853b8b3e360aa48e5bd23689a3a2eb3946d6f0b17e8339c5e"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5386d1f21929f2eb45093619ae74508e4e26c1b11f5a89e46f7cf841cab7a41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e0edcfe00304ec595cf09c87a682f17b342efb1f44665fdb12badd168b1048b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e0edcfe00304ec595cf09c87a682f17b342efb1f44665fdb12badd168b1048b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0e0edcfe00304ec595cf09c87a682f17b342efb1f44665fdb12badd168b1048b"
    sha256 cellar: :any_skip_relocation, sonoma:            "65792664b36a7a413988eed11b20195f96df59e7419dc6a9382f1781fd2f9b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1acc10058b0bc46874f1446064e9d36c6c05d3764cb3ecb99fc072cee683913d"
    sha256 cellar: :any,                 x86_64_linux:      "7250a6238833281939ed4270d2cd93fa7f4d5d7b37fa09f236fb59bd50d1cb68"
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
