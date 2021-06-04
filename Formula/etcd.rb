class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.4.16",
      revision: "d19fbe541bf9c81e2d69d71d1068bd40c04de200"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98d4d3db7514d67bc1c202e0b21238d6f62d4ec89ffe73bbe92eff2e0827765a"
    sha256 cellar: :any_skip_relocation, big_sur:       "09635a11e558befedc4768acc4f4541586564e5e5da7c5dfcb7a5deaf623df39"
    sha256 cellar: :any_skip_relocation, catalina:      "4729678ad915171849e0185c73d24c48162c7f28af056faa40a2d31e0c8bb87b"
    sha256 cellar: :any_skip_relocation, mojave:        "185eafd66633ad22b38155677003d5fadec6e6e72087a1ead2adfed4c99d13aa"
  end

  depends_on "go" => :build

  def install
    # Fix vendored deps issue (remove this in the next release)
    system "go", "mod", "vendor"

    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
      bin/"etcd"
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
      bin/"etcdctl", "etcdctl/main.go"
    prefix.install_metafiles
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
      on_macos do
        if Hardware::CPU.arm?
          # etcd isn't officially supported on arm64
          # https://github.com/etcd-io/etcd/issues/10318
          # https://github.com/etcd-io/etcd/issues/10677
          ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
        end
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
