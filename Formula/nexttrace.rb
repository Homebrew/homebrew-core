class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/sjlleo/nexttrace-core"
  url "https://github.com/sjlleo/nexttrace-core/archive/refs/tags/v1.1.7-1.tar.gz"
  sha256 "1c937a9f7c2f1d4a3e71e63db2929a5b24d438c63efd9715b00277f1b3add4cb"
  license "GPL-3.0-only"
  head "https://github.com/sjlleo/nexttrace-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "681741032c8d303c6f545f20ff059f32203663f5145202a5143cfee505e77a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "681741032c8d303c6f545f20ff059f32203663f5145202a5143cfee505e77a93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "681741032c8d303c6f545f20ff059f32203663f5145202a5143cfee505e77a93"
    sha256 cellar: :any_skip_relocation, ventura:        "8ec527e5c985b268eaf60231c243f92a0718756fdebcb71489e1d22672f0e343"
    sha256 cellar: :any_skip_relocation, monterey:       "8ec527e5c985b268eaf60231c243f92a0718756fdebcb71489e1d22672f0e343"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ec527e5c985b268eaf60231c243f92a0718756fdebcb71489e1d22672f0e343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f8b8d14f176d0782d11635d1461574a11cfc9eb4ddd5d4052b4da5ed8bffa96"
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
