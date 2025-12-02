class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.6",
      revision: "d2809cf0019f84c221e026bb2ac6486d011b1d91"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d2a1efbce2ed3ac6ac44ad502b455693d64eb629e2912a58292353f4396f2a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d2a1efbce2ed3ac6ac44ad502b455693d64eb629e2912a58292353f4396f2a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d2a1efbce2ed3ac6ac44ad502b455693d64eb629e2912a58292353f4396f2a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba5a7ac7d8dc66a74425bbe0e22a0e031197b01c4d02d470df4d785281d44f36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cad1c08b150c517992eef48b9aa4cd9bde41380f69180c9ede2797bfc1a261c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5e7f4d7e3b4ad69a5caae7e51f8199e522bef94c72ba89324f2f948a05057e"
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
