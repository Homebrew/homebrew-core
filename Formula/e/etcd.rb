class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.0",
      revision: "f5d605a93abe2fdfa13880aab0f1f3a4203628dd"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5822986b8b37a8bbceb63036e641d42b5175b87b01089194a85877f488310318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5822986b8b37a8bbceb63036e641d42b5175b87b01089194a85877f488310318"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5822986b8b37a8bbceb63036e641d42b5175b87b01089194a85877f488310318"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa393ee9597f642ac5cc08e19f0b2c203fef8e2ac4fad8c77803c4322aac889e"
    sha256 cellar: :any_skip_relocation, ventura:       "aa393ee9597f642ac5cc08e19f0b2c203fef8e2ac4fad8c77803c4322aac889e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de410cd80c4ad81664ec078f17fe0a9e5c8247a7a716933450a1c4f703665aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37c4e1d721ce6952be9d64a35feb382c0e09d7c4e1c8d50e899fa8d5611db9cf"
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
