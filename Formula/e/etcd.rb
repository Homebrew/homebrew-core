class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.6.4",
      revision: "5400cdc39b829ee5dadacb77002256cf86357da1"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0efc14a7f94223d6fde8efc48dcd045962f108ec8b3558f56ad26159f50df96f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a2472f8be75f7a366c3cb5152b5c7851baf1500025cc63da143a120fa7e313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a2472f8be75f7a366c3cb5152b5c7851baf1500025cc63da143a120fa7e313"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08a2472f8be75f7a366c3cb5152b5c7851baf1500025cc63da143a120fa7e313"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3cb603edd8c51b88965799e288f4f2b13a5474d783a492026cc89455ada0424"
    sha256 cellar: :any_skip_relocation, ventura:       "d3cb603edd8c51b88965799e288f4f2b13a5474d783a492026cc89455ada0424"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24dd085dc7b8d7fb59409d80ded252887c9d85f28a8ac8287d4e9ecd7e525434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53a7c85c5a5ded8f6093aa0318508032035c49dbd83987e1423d241ec84709c9"
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
