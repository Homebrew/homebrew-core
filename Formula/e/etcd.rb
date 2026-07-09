class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://etcd.io"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.7.0",
      revision: "4d71f7c83a2cef992d57abd3284edfaf66c91a4a"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6659069ba339a43b9870e1f7ed45f740c93ab1380c505c73e5e69bb7d2b22faa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6659069ba339a43b9870e1f7ed45f740c93ab1380c505c73e5e69bb7d2b22faa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6659069ba339a43b9870e1f7ed45f740c93ab1380c505c73e5e69bb7d2b22faa"
    sha256 cellar: :any_skip_relocation, sonoma:        "38127fa4ebb28293bf9dae2778a3dedb4e139eae0ac3af1c81beaa6979f63b56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "629a56e26d176bc8490893019a315770dec437682c9f76416e198cf56f1cf6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b87dd77a7be9351a68396595530270f0debe357b500b3c55db02ecd0f851d9"
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
