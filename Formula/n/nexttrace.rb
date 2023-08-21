class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/sjlleo/nexttrace-core"
  url "https://github.com/sjlleo/nexttrace-core/archive/refs/tags/v1.1.7-1.tar.gz"
  sha256 "506db2d92404b8923dd3caaaeab2f3ba2b828e018d3a9721419802a17e828057"
  license "GPL-3.0-only"
  head "https://github.com/sjlleo/nexttrace-core.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edb6bfe29ab3c66487adbc6ee863a1bfd6f1006741b9a4dbde48d26858d29c55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a5005807f8844aa356e676de3542b86ddc45ff2bc527a6d90f95f6b6364b45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19ad313119e095cc6c3e05bf18cdd4d918b0b9c6c485a2de1889b878fc1f8044"
    sha256 cellar: :any_skip_relocation, ventura:        "76eb9765cdf3570f8ac933de43a19b5b8edecee1d520fdaffbdc1861734ad01a"
    sha256 cellar: :any_skip_relocation, monterey:       "55dd831fe6c888e5050e67dbd1fa1a21883227d0122eb6bf6e7d19be0d206e8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "027b47219c2e4a8af3a39d1234e219d61421e1140ade6613b43bc235e7c180fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58bffb923564bc8d3487cb6a41a04ac3cb15fed7d0f236060c3e8be32120598e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/xgadget-lab/nexttrace/config.Version=#{version}
      -X github.com/xgadget-lab/nexttrace/config.CommitID=brew
      -X github.com/xgadget-lab/nexttrace/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` to start
    output = if OS.mac?
      shell_output(bin/"nexttrace --language en 1.1.1.1 2>&1")
    else
      shell_output(bin/"nexttrace --language en 1.1.1.1 2>&1", 1)
    end

    assert_match "traceroute to 1.1.1.1", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
