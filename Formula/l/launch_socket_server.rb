class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/mistydemeo/launch_socket_server"
  url "https://github.com/mistydemeo/launch_socket_server/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "507184544d170dab63e6112198212033aaa84edf0e092c1dfe641087f092f365"
  license "MIT"
  head "https://github.com/mistydemeo/launch_socket_server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24960fd5bd4f03830d135a4cc6150ec49b516ce8c3bdaf16b240669310565536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6974a57e3a6bd5f01dc3b62d4a4592afb791af68f230b7ea5e60a46cffc0d395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a59f265b9a67885cd73be07b4fa591b0ff76e382ac7c2db5099e02d2212bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d09862a50bec1441d8d5cf4eabb2318942fab969ebddb67b9f3739e784e5a13"
    sha256 cellar: :any_skip_relocation, sonoma:        "570f75f0fa24b34b03a278f1dc9f46f554c651b966204943fb3b5f25f412ee81"
    sha256 cellar: :any_skip_relocation, ventura:       "38b8161c24c87504fe237154e1b287d1493f9a16f41bced1f942ebb5ce9b6d06"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run [opt_sbin/"launch_socket_server", "-"]
    environment_variables LAUNCH_PROGRAM_TCP_ADDRESS: "127.0.0.1:8080"
    keep_alive true
    require_root true
    error_log_path var/"log/launch_socket_server.log"
    log_path var/"log/launch_socket_server.log"
    sockets "tcp://127.0.0.1:80"
  end

  test do
    assert_includes shell_output("#{opt_sbin}/launch_socket_server 2>&1; true"),
      "usage: #{opt_sbin}/launch_socket_server"
  end
end
