class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.7",
      revision: "e838ef116fc368b321ddf2e424167b15174fb80d"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c879b6050f7e12878c631b9da99b17edad39975c2aff760dc76bda2f49a489e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c879b6050f7e12878c631b9da99b17edad39975c2aff760dc76bda2f49a489e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c879b6050f7e12878c631b9da99b17edad39975c2aff760dc76bda2f49a489e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c4f4f57d43149049f2b8e4d7b60b20a83d188297d880f40a8d011d196a1fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "328ad1a54c6b66d1bef7103c3e28da79668d3a340fb698d4cd682fa401fb35c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86571662143deb43fddcec3a6dc12cba0e8184df711e356d607284f15c0b2d6b"
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
    etcd_pid = spawn bin/"etcd", "--force-new-cluster", "--logger=zap", "--data-dir=#{testpath}"
    sleep 10

    key_base64 = Base64.strict_encode64("brew_test")
    value_base64 = Base64.strict_encode64(test_string)

    # PUT the key using the v3 API
    put_payload = { key: key_base64, value: value_base64 }.to_json
    system "curl", "-L", "http://127.0.0.1:2379/v3/kv/put", "-X", "POST", "-d", put_payload

    # GET the key back
    get_payload = { key: key_base64 }.to_json
    curl_output = shell_output("curl -L http://127.0.0.1:2379/v3/kv/range -X POST -d '#{get_payload}'")
    response_hash = JSON.parse(curl_output)

    retrieved_value_base64 = response_hash.dig("kvs", 0, "value")
    retrieved_value = Base64.decode64(retrieved_value_base64)

    assert_equal test_string, retrieved_value

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    Process.kill("HUP", etcd_pid)
  end
end
