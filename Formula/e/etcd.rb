class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://etcd.io"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.12",
      revision: "90b034a02766ab83e425f9b79262311f508dba4e"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e350b6c62a122012e7a11c1d772e69ecac520c0b9c708774502b5b11f988eef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e350b6c62a122012e7a11c1d772e69ecac520c0b9c708774502b5b11f988eef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e350b6c62a122012e7a11c1d772e69ecac520c0b9c708774502b5b11f988eef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7b8b73d5e6aa3b6a9a7c6b89ef00f52264eaa8a3407905fac714e1aac49e6af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c291308bddde79820ced3f7721e82eb2a93b45154b1ce128451d3d33fd52339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84772fe095eda68e860919019a4af4df7f85d3730ff5f06371695971adbd8896"
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
