class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.6",
      revision: "cecbe35ce0703cd0f8d2063dad4a9e541ae317e5"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9326f44eec1e546a9839b8a8f104a6c769ebec0b538c521bff8d1e88f6622e14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "063a363873e59ed1bc6b1b9858413735e767391d1cd54f531a5db372c96f4c02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7abef5d1e326aacf0758f4f6a17d41ea229f0059f09b391ac1f442f3abac557"
    sha256 cellar: :any_skip_relocation, ventura:        "6ccaaa4e48003014895ec78306dc0ff7c11fd1f653fee025bb96ef518374e39f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e18f0c8acccf8e4cd3b6afeb7aba59cd8205671345dc73e945e110c3e93c5d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a60fd3d112305f5837a6c3691573fab12204f6753534a146f2ed6bc5b282c657"
    sha256 cellar: :any_skip_relocation, catalina:       "8ed59229b96fc6a7ee5b4190f92d9e1360e6ea363350db6e719dea21e5a45ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bba25600c24799d0b24b90c0f655e59de638698d424dbb172ba165eba6babd8"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install Dir[buildpath/"bin/*"]
  end

  plist_options manual: "etcd"

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
