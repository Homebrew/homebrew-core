class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "09648d2eb93b200cfd527a747970cb96a967c7792ea4f9d941903e7a2547aab1"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f596b894443ba2eaa7a9e05301e7539af4230219d620158da39e3a7f030a55a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f596b894443ba2eaa7a9e05301e7539af4230219d620158da39e3a7f030a55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f596b894443ba2eaa7a9e05301e7539af4230219d620158da39e3a7f030a55a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5b5d77563d7b91803ecfcaa9b0992564b39758282fbab473dedcac69fd469b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "459eb0dbb92f5edda00a8033d762f2245f40227382bda377b3b2dfd9e7ee1f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f86b4c36489ac402476574dc1cbd7f60f27448b1664c9560c72d5c1f13a9ef69"
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
