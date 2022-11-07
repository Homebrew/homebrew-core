require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.10.0.tar.gz"
  sha256 "4c9ec541a77314b11f23f2eff1394568ea9180f1f3cc3f098cb3e7977dbfd7a5"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e60c6cbad7cf26be81a3ecf4e67d76860cd0dc51e313ec7b0a84a9f0cca1866e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f36ad1c8bccee48018a89ba866c95e82c6924a7ddd65b625c0e815bfc9add575"
    sha256 cellar: :any_skip_relocation, monterey:       "c7cb92de2c6cfa35963ba9b236f9770be2f3e7c7c34217ed66410a01ce4321d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "67f7d0341b169a14d77ed62616bb6b933772637a891a2eeac370cf5944f634a1"
    sha256 cellar: :any_skip_relocation, catalina:       "6f13cf0d008d4d2b395e19a85aa419c1a7e4c46d624db2ec3776abb2d201506d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fadc331abb4ddfacc2e23c46f9e74782cd31e52019fe9d606c814fe430794473"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node@18" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    Language::Node.setup_npm_environment
    system "make", "dep"
    system "make", ".jssrc"
    system "make", "chronograf"
    bin.install "chronograf"
  end

  service do
    run opt_bin/"chronograf"
    keep_alive true
    error_log_path var/"log/chronograf.log"
    log_path var/"log/chronograf.log"
    working_dir var
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/chronograf --port=#{port}"
    end
    sleep 10
    output = shell_output("curl -s 0.0.0.0:#{port}/chronograf/v1/")
    sleep 1
    assert_match %r{/chronograf/v1/layouts}, output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
