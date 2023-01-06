class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.15.2",
      revision: "4946d49abdc35810254151923bab30fb3cc2c004"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36ee6bdaefd057942dcc2a5a4d387df5d47bb09e487edc80c1240078735250f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d52547750440908fc8f1646034117ef4b5525b70e20ecda8cf2c2ce5ca1d988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "485932b715aca6f2933b3de52fad0ae62f810f54074a188fc0dca169e386a854"
    sha256 cellar: :any_skip_relocation, ventura:        "43c016c67b3a697c9e0a3cd75d7de70d697424b13009a37e3864fd077260b90b"
    sha256 cellar: :any_skip_relocation, monterey:       "0893ea92f8fac15b65c5898cb3b3f460e5939a0d1c4445689a962b0956b18079"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab5cd04e3819d96d32178bed4ffb845b4bfe12e0f6d55f97ba165863fc058fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a203585eb808b95325695dd101f8d4dc7d637fa0055e93964b6c89372c0195f0"
  end

  on_macos do
    depends_on "ldc" => :build
  end

  on_linux do
    depends_on "dmd" => :build
  end

  def install
    target = OS.mac? ? "ldc" : "dmd"
    ENV.append "DFLAGS", "-fPIC" if OS.linux?
    system "make", target
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = fork do
      exec "#{bin}/dcd-server", "-p", port.to_s
    end
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system "#{bin}/dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
