class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.2",
      revision: "6088ddf90a3c481f7902dd919e7aa0ff9ec57ad5"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b406b13a9ffb145188480c6f0f07dda2ffbe0f0356e06862e1797645c51cb1c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b406b13a9ffb145188480c6f0f07dda2ffbe0f0356e06862e1797645c51cb1c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b406b13a9ffb145188480c6f0f07dda2ffbe0f0356e06862e1797645c51cb1c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7f6116f9786afc4768dc4f12d35549277f806740cd1174a2550a78cfd8e0412"
    sha256 cellar: :any_skip_relocation, ventura:       "b7f6116f9786afc4768dc4f12d35549277f806740cd1174a2550a78cfd8e0412"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ecd57ccac3bb4e797f5e769833e80343258821177064e0af3b1658241761186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c734d2b25c765644004b6f2bddd73ab3f037257c7d4f69a29f27e94174b370"
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
      exec bin/"etcd",
           "--force-new-cluster",
           "--logger=zap",
           "--data-dir=#{testpath}"
    end

    # Wait a bit for etcd to initialize
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
