class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.5",
      revision: "a0614505aff9b8ff469e9c59c2d979a5936d13f4"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d66a199d4ac66b3a9f70ebf383dbf6bc4102d4ccef91711ee777831af0b4183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d66a199d4ac66b3a9f70ebf383dbf6bc4102d4ccef91711ee777831af0b4183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d66a199d4ac66b3a9f70ebf383dbf6bc4102d4ccef91711ee777831af0b4183"
    sha256 cellar: :any_skip_relocation, sonoma:        "2961b68bbfdfc6280427f39eb3abe30c7287219c46a5c53bd91e179f40cafa54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56d1ded25af32cb096aee623153e12c18b0fdeb7dc6ecbcbba66aa2375acf5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d0748e84f8a7f4b150758337f7dd2db2207dac1364ec64c32ceff2f70bea70"
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
