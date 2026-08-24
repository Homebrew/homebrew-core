class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://etcd.io"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.7.1",
      revision: "5e7fd0de9a57db03ecc11794dc40403a734c07bb"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e77c3f1ce01a9acf550251a874879769d738fa893dce62ac3c9ffa84197dba4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77c3f1ce01a9acf550251a874879769d738fa893dce62ac3c9ffa84197dba4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e77c3f1ce01a9acf550251a874879769d738fa893dce62ac3c9ffa84197dba4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8de28b8fc4b368984a14eafeefd824b8ab46a39aea039ce8d32dafae1938578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f3b43636ec5cd82663db1a232217483158de6687561dcded40419d1595c6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2536b0d8da2ccc0367830ea57888093e0eb01c9c91717048385e1bedbf5200e7"
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
