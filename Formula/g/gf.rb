class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "00cb34258148f6991120eac5a0ca8e5cfa4231d3cbf90fdc01786f35aeead309"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57cae2c7b968c2b94bdc107a19ef036a9dfee63e7358bdba19690cc9f485679f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57cae2c7b968c2b94bdc107a19ef036a9dfee63e7358bdba19690cc9f485679f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57cae2c7b968c2b94bdc107a19ef036a9dfee63e7358bdba19690cc9f485679f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c90e4e05253d08f0a7572468de73cb1da678a94bdb67ca2c50a8a743d15220d"
    sha256 cellar: :any,                 x86_64_linux:      "44f667802948deecad49efb8c48bb2800fdb5145a1835fc920ce7e5b10a2f8d4"
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
