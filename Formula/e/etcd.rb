class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.10",
      revision: "db8d13a5421fcbd1c5825a148735b80c7d36cd2d"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ec9cdf3d70bb68e9084320db09eb550d0dcdd6adab47a0527edcaedd9e76db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec9cdf3d70bb68e9084320db09eb550d0dcdd6adab47a0527edcaedd9e76db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec9cdf3d70bb68e9084320db09eb550d0dcdd6adab47a0527edcaedd9e76db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d303cf4fb174e64df85f10be8d0aabaeeeffdc661fc8d953852b0331c88679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a6a9d354808674b1b9cedf0bd2a216dfedad767a90bd834726245a87a56b1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb7a1266715ef25837f9a597de292993f6cbafd947a94dca515e0f6c6f485f4"
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
