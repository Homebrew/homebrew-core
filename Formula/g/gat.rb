class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "84adec2d9ebe93b20bfe4d4d533be9ad65f509de1a611c8bfca359c66ed2eb8f"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bcb908eccdaf495cb4d90cb54b4ea88dd16ee47a8940051fc030d74b0fb31ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bcb908eccdaf495cb4d90cb54b4ea88dd16ee47a8940051fc030d74b0fb31ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bcb908eccdaf495cb4d90cb54b4ea88dd16ee47a8940051fc030d74b0fb31ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3b9e2de53607999b15e40531653825af35caee4cacded6094cf31ac723a75b"
    sha256 cellar: :any_skip_relocation, ventura:       "0a3b9e2de53607999b15e40531653825af35caee4cacded6094cf31ac723a75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745163509ff748c88f5b39553ed0b1463e073c61ef268f7fd46a8983c7c43bd5"
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
