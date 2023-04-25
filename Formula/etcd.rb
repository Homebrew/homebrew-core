class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.8",
      revision: "217d183e5a2b2b7e826825f8218b8c4f53590a8f"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce3f50bf1dfdaaaf686520e35329023cdad96ddb43b5d4162da4b0436a283e07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce3f50bf1dfdaaaf686520e35329023cdad96ddb43b5d4162da4b0436a283e07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce3f50bf1dfdaaaf686520e35329023cdad96ddb43b5d4162da4b0436a283e07"
    sha256 cellar: :any_skip_relocation, ventura:        "e62178ec5acae5479e10d409fc3a910d8f68af2378d166f0c0921d3dbb9a35b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e62178ec5acae5479e10d409fc3a910d8f68af2378d166f0c0921d3dbb9a35b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e62178ec5acae5479e10d409fc3a910d8f68af2378d166f0c0921d3dbb9a35b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c7e784670737596a810fed70e52cbd547e078cafae2a03564ca1ae72ec1692e"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install Dir[buildpath/"bin/*"]
  end

  service do
    environment_variables ETCD_UNSUPPORTED_ARCH: "arm64" if Hardware::CPU.arm?
    run [opt_bin/"etcd"]
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    test_string = "Hello from brew test!"
    etcd_pid = fork do
      if OS.mac? && Hardware::CPU.arm?
        # etcd isn't officially supported on arm64
        # https://github.com/etcd-io/etcd/issues/10318
        # https://github.com/etcd-io/etcd/issues/10677
        ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
      end

      exec bin/"etcd",
        "--enable-v2", # enable etcd v2 client support
        "--force-new-cluster",
        "--logger=zap", # default logger (`capnslog`) to be deprecated in v3.5
        "--data-dir=#{testpath}"
    end
    # sleep to let etcd get its wits about it
    sleep 10

    etcd_uri = "http://127.0.0.1:2379/v2/keys/brew_test"
    system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
    curl_output = shell_output("curl --silent -L #{etcd_uri}")
    response_hash = JSON.parse(curl_output)
    assert_match(test_string, response_hash.fetch("node").fetch("value"))

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end
