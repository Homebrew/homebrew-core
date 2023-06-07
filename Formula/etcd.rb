class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.9",
      revision: "bdbbde998b7ed434b23676530d10dbd601c4a7c0"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "392a02b68c720505ba12537d48c06a1f74e4c0cf88547b6806209952c20205f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392a02b68c720505ba12537d48c06a1f74e4c0cf88547b6806209952c20205f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "392a02b68c720505ba12537d48c06a1f74e4c0cf88547b6806209952c20205f7"
    sha256 cellar: :any_skip_relocation, ventura:        "79b7ffc5362275dfb83798d3bc3c2b1fdc01334d704e4ecd8ca28e420f8502bd"
    sha256 cellar: :any_skip_relocation, monterey:       "79b7ffc5362275dfb83798d3bc3c2b1fdc01334d704e4ecd8ca28e420f8502bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "79b7ffc5362275dfb83798d3bc3c2b1fdc01334d704e4ecd8ca28e420f8502bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d1ace40ee0123e833a69df287f38ec75708c8e1716cee4734166f8278cd1c1"
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
