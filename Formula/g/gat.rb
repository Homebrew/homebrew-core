class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "536cd5219d75c20f9cf10fd5ab5ce1a7415513b240636e76726539b2d9c63de3"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "088a70bb3a504a16638f378f5972619bc9315e824b434f6be458d5daecbb5bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "088a70bb3a504a16638f378f5972619bc9315e824b434f6be458d5daecbb5bad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "088a70bb3a504a16638f378f5972619bc9315e824b434f6be458d5daecbb5bad"
    sha256 cellar: :any_skip_relocation, sonoma:        "de9a1cdadace9dfa46b6e8e2b16885d920fe4ededc1c29d50c83d13261b8d534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c548795052c11d8013ba1d4a2cd8f2aba00e465cdc968c963e6b835175214b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02650f3ac67a71060f3f14a4f8e90ebe6313720b4bf6450228bfdeff96e8a4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
