class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.19",
      revision: "815eaba08570ab0a123d65c12ef419e5b3f8e250"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e0e099be6db567d0c1ef961adeef1656100fbe2b3393d68174794f43ce9654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e0e099be6db567d0c1ef961adeef1656100fbe2b3393d68174794f43ce9654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66e0e099be6db567d0c1ef961adeef1656100fbe2b3393d68174794f43ce9654"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa8bb0aa7d9a509d18f75bb9781c1319517a4f8d258f3bdc30c3547ac8fcc3c"
    sha256 cellar: :any_skip_relocation, ventura:       "eaa8bb0aa7d9a509d18f75bb9781c1319517a4f8d258f3bdc30c3547ac8fcc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69faa2bd694fd31d7059047aca6b912d6cc56ad8ba43bf84986605aed5834fb4"
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
