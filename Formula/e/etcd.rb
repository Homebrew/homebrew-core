class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.11",
      revision: "ec166e2292a58365c90e96fcd206b3b74938d49d"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d72ae000403c423f3890ae1bc22132eb918f8d8e7c3851c8299ee1344902e8ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d72ae000403c423f3890ae1bc22132eb918f8d8e7c3851c8299ee1344902e8ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d72ae000403c423f3890ae1bc22132eb918f8d8e7c3851c8299ee1344902e8ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0888746a298aacbf36960117eaf5aec6642eace02fcd63e522e2cb588ff5a63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d175949aa7d12e300313b9f879961baa2877788ac8d3d1d0847b4e5c19e0c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e82b2d498fcb8621946b323e1b9b87b2a34e29876e06408e2358a85a72af34"
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
