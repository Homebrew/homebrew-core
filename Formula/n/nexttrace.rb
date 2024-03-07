class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "0f353397fde115480e60e08a9d5ca895c7ff2854e61c66966d61e4022a2ba2c0"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df128fd2b2ca00496016dedec892e97431a2db7ed99185640199322811302883"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "340b7d6eecdbf91691c4fbe9cc5f5f454491d194ec5e196cc56c3be638d9f916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c66277e4839fdd61a2ab8c02324b4c9a335da8587150d97b63c475bcf10e15e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6bc164cbc5aa1b2071af0f759725f8003f57fd9c878345c9386206e90869651"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a0d3cf1f51f947a0a5df048d58a48c52a2c12958767be194dc761a8fbfacb0"
    sha256 cellar: :any_skip_relocation, monterey:       "9a0bc8ab0869ee452b62b5bdb3a8d98b4497ae88c4acea7b1b6872e4374cf6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea1a4d023c2ae3b3e2d431f53b4f405c60d283ae7ca31992c7a0afe128f5c33"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` for linux
    return_status = OS.mac? ? 0 : 1
    output = shell_output("#{bin}/nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API]", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
