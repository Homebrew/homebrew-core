class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.15",
      revision: "9a5533382d84999e4e79642e1ec0f8bfa9b70ba8"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b3f49d4bbb15b69232634a1a709f1bfcf970ebe8c410991eab8354956410554"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b3f49d4bbb15b69232634a1a709f1bfcf970ebe8c410991eab8354956410554"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b3f49d4bbb15b69232634a1a709f1bfcf970ebe8c410991eab8354956410554"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f56a47ec9ffefdbef662b1ce0a133aaa2ca785bb836a8182c866ddb237f8cc0"
    sha256 cellar: :any_skip_relocation, ventura:        "9f56a47ec9ffefdbef662b1ce0a133aaa2ca785bb836a8182c866ddb237f8cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "9f56a47ec9ffefdbef662b1ce0a133aaa2ca785bb836a8182c866ddb237f8cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb246c6e89a91ae277284a27cae9de5dbdf78cc3638d32a48b62753647f9af6"
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
      if OS.mac? && Hardware::CPU.arm?
        # etcd isn't officially supported on arm64
        # https://github.com/etcd-io/etcd/issues/10318
        # https://github.com/etcd-io/etcd/issues/10677
        ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
      end

      exec bin/"etcd",
        "--enable-v2", # enable etcd v2 client support
        "--force-new-cluster",
        "--logger=zap", # default logger (`capnslog`) to be deprecated in v3.5
        "--data-dir=#{testpath}"
    end
    # sleep to let etcd get its wits about it
    sleep 10

    etcd_uri = "http://127.0.0.1:2379/v2/keys/brew_test"
    system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
    curl_output = shell_output("curl --silent -L #{etcd_uri}")
    response_hash = JSON.parse(curl_output)
    assert_match(test_string, response_hash.fetch("node").fetch("value"))

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end
