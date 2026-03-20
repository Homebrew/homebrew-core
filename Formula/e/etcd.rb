class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.8",
      revision: "4e814e204934c3c682d9e185db1dfb646d2510b3"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1904fa2d037fa83abe4c064dc008b98bafb3a40555182e279f52542e369771d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1904fa2d037fa83abe4c064dc008b98bafb3a40555182e279f52542e369771d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1904fa2d037fa83abe4c064dc008b98bafb3a40555182e279f52542e369771d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bfb689cb93e001d567697f89d60b21c9e9ca2afaf1e83906b5e11c0043e2245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5707760efeadebcd3066d47a867d9b587a430e6aa7c20487c3f89c28010a5da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fc9f80896726bf4a80e50d5d6ed8b3a14c567dfe10448f4ba963ad1ad68a71"
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
