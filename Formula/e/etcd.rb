class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.9",
      revision: "85651fa521731aaecad76ff81dee5450a766c874"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7216b9364d605d2bad9ce8f6ad209d03f334ede4e2bf186d2c2990f8f917ad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7216b9364d605d2bad9ce8f6ad209d03f334ede4e2bf186d2c2990f8f917ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7216b9364d605d2bad9ce8f6ad209d03f334ede4e2bf186d2c2990f8f917ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9dfee56d492b07c51cc6726397e08276501ea7c28deec1a78912542fb256d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4c86c08e2573f9e1c4ae1dc42d80cc21daab583ded98b5f0b28a20a0db298f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53203859213ba36662661b4e8df59d72c7e29d9309d4cb47acf6a4656f21127d"
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
