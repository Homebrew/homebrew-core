class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "5f4c217b67a62433a738991b29bc7dee31e748ab7e9eb03a5505b49afa27ec5b"
  license "MIT"
  head "https://github.com/DarthSim/overmind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a110d69ff6f691658ed2f176271371ff54e2aeeeab73d4ccd124ed616d7f8f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "984c9e975dda90a96ded9fa43a6b70110c80ef3efc4604ceb274547a035c22c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d26b6161cefed451e50c007ba9bb6601a8e0ca21f297720a74bfd38075866e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eb53694a8b87289a4f2dc5a307926ce841becb78f141a625608c8ec2d798a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "d91928daa9df19605d347d0f20e36b98108b2dd131c55161a976cc0d86738d74"
    sha256 cellar: :any_skip_relocation, ventura:        "bae2f9b47e7fb846de0b69cf21e464e2896777fb189a2aa557a2afd69e9d8fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5d5836b5710febf70d33af79e507cccd6e505d39d8c2943067f36f649786ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "10e30d50a5e5b5eb170652d62c0e8dee30a5d0d545bcd8a8a7e365b4d931602f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71554c46da7c312dd2a56e5c8f37dde2923adbc4fdb1e448d0a748c0bf1e54bd"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    prefix.install_metafiles
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'; sleep 1")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
