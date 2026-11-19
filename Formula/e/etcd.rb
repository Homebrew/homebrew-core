class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://etcd.io"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.7.4",
      revision: "2e8a5c99e4982c8d4c521be15364ea4c5c68a489"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43cd01060f5b37b28b72b5c2268b3de00ae15af16834215388be880c1428c2f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43cd01060f5b37b28b72b5c2268b3de00ae15af16834215388be880c1428c2f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43cd01060f5b37b28b72b5c2268b3de00ae15af16834215388be880c1428c2f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b86822a248e03aa1e480b5329a5c5ab01b95416f4595c9b778fcdd75f8541faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "723ef7c76dfc17980b79492176666ebe3c68d5e9a23464f152b6a191e7903ccb"
  end

  depends_on "go" => :build

  # `test do` block runs a local etcd server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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

    key_base64 = ["brew_test"].pack("m0")
    value_base64 = [test_string].pack("m0")

    # PUT the key using the v3 API
    put_payload = { key: key_base64, value: value_base64 }.to_json
    system "curl", "-L", "http://127.0.0.1:2379/v3/kv/put", "-X", "POST", "-d", put_payload

    # GET the key back
    get_payload = { key: key_base64 }.to_json
    curl_output = shell_output("curl -L http://127.0.0.1:2379/v3/kv/range -X POST -d '#{get_payload}'")
    response_hash = JSON.parse(curl_output)

    retrieved_value_base64 = response_hash.dig("kvs", 0, "value")
    retrieved_value = retrieved_value_base64.unpack1("m")

    assert_equal test_string, retrieved_value

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    Process.kill("HUP", etcd_pid)
  end
end
