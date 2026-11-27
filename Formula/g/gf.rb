class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.10.6.tar.gz"
  sha256 "d3617fd80f4a697702b4a0136201d39e45f1ab7872f5f57b4b6e893896b078fb"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    manifest_sha256 "64fd6bcd7f66c051f00cf14c798302d2a828aa9602b58ebaf405715325806dc3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "509189f4713266d952d9e424913a10c5f82223106648250b4188a379f910eb8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "509189f4713266d952d9e424913a10c5f82223106648250b4188a379f910eb8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "509189f4713266d952d9e424913a10c5f82223106648250b4188a379f910eb8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d1accf85d422c625b7b8133c09fa1446a95e2743ceedca46893b3d1af18cb4b"
    sha256 cellar: :any,                 x86_64_linux:      "1d9d1a86de60712ee9d6348562510146e6209c91971588298ce6d62182205799"
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
