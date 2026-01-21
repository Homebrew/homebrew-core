class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/mistydemeo/launch_socket_server"
  url "https://github.com/mistydemeo/launch_socket_server/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "507184544d170dab63e6112198212033aaa84edf0e092c1dfe641087f092f365"
  license "MIT"
  head "https://github.com/mistydemeo/launch_socket_server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd7f62d360a2d0e3ccbc0d127e6c93cf7b04341547a0cc47712e9cc30bfada44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f9379e42b9f24b9f1d7c8e4f899901ad90999fe69c526c081c883e813cd36ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39407abb6a275dc2f8d7cee19b56126213e46ed61e6ef0d9e0eff631112c3e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bffce7fd244160abb5333fed263f40e868bd09c2da174a51d7be6b255101992f"
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
    sockets Socket: "tcp://127.0.0.1:80"
  end

  test do
    assert_includes shell_output("#{opt_sbin}/launch_socket_server 2>&1; true"),
      "usage: #{opt_sbin}/launch_socket_server"
  end
end
