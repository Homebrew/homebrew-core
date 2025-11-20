class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "d616b89465d488878ed2e1f79e66f8af5b5c2f1d3cf75c2b08e04fb04752d187"
  license "MIT"
  head "https://github.com/DarthSim/overmind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7e75f7028eb9c455f06ca7d1bbfdc0dd56a1b93b50f957a2b43ae25850737eca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "63ad87a46c888c096259183252addcd8ef53d521bf1a5e36fa3ef79b4a1c526a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "170345488efff9664a6e6f1c203e9f252f2a6b36f3b19a574a69e2a504ff88d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cefab99b19b428357d41d4f27186c68a149c6b67dd317ba71e7cc985e3ab824"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b5121a20d14591466ebfa082329d902ced52c30e7c257bebe0c6141717c29ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "75d9f3f07a21c2bd979f50fd520bec07a4221fecf0e70afe2e167d91ca263360"
    sha256 cellar: :any_skip_relocation, ventura:        "d10e4a237a80de7a6119f79ab10304623e7cb5dd42d74e5feb1382bd74642862"
    sha256 cellar: :any_skip_relocation, monterey:       "8f39c51a41a651b932147937384d1091dd0b86ae15a040bd6dbd96c2db5f3cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "905ba5269700b1a1484869ab1a8450752ff42a38f54a070a6cb55dceac025dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8a085f0aae6ddeec87817674bc44a085c2ae884e0a90568b23d9e37c5a3cee"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'; sleep 1")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
