class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.4",
      revision: "08407ff7600eb16c4445d5f21c4fafaf19412e24"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4daf47ff317a297fe7e508ab74799ed4d9a133aafc30cd1ed510f7007abbc958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be55356384e60a8a9096ac91129a185acee1b98d04a3c21faa4310f22fcc4cfe"
    sha256 cellar: :any_skip_relocation, monterey:       "4813890404b36cb64f1c09d843a69b8938602bda2a323b1d55c70c3ea8dc987c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd8b99b2ae658229c22f0adf9a6c2a8f0fbabfbe07d9c8418d660c329d71a560"
    sha256 cellar: :any_skip_relocation, catalina:       "63855b1fefa7f1f64e43e1ffd7b74c79b4a04ca58973a7ed67e3d54277e3887e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea276191c22789dd1e2590bef8ced3dbf1d00432550ef4fe0a4451b7ca349862"
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
