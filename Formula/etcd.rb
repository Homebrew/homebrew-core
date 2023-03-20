class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.7",
      revision: "215b53cf3b48ee761f4c40908b3874b2e5e95e9f"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fe729530dc6c4c3b3769c131b231718b0a211d9d423dbdc74400401c541c037"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe729530dc6c4c3b3769c131b231718b0a211d9d423dbdc74400401c541c037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fe729530dc6c4c3b3769c131b231718b0a211d9d423dbdc74400401c541c037"
    sha256 cellar: :any_skip_relocation, ventura:        "5bccd38618d5a65fc3ad05fe99447dfa968c22a3d27a98acaabc92c9fb44e994"
    sha256 cellar: :any_skip_relocation, monterey:       "5bccd38618d5a65fc3ad05fe99447dfa968c22a3d27a98acaabc92c9fb44e994"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bccd38618d5a65fc3ad05fe99447dfa968c22a3d27a98acaabc92c9fb44e994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a267f2c3db4e1063e703e1243daca054cad510c99039d3f17b0bca39089c6b"
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
