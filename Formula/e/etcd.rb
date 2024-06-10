class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.14",
      revision: "bf51a53a7e0452a7e44783c24ec048e6981dd2d7"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29f13588038a24465d6be1d22714e2f05502a013fda8d4a1f0102f1eeb5ec06f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29f13588038a24465d6be1d22714e2f05502a013fda8d4a1f0102f1eeb5ec06f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f13588038a24465d6be1d22714e2f05502a013fda8d4a1f0102f1eeb5ec06f"
    sha256 cellar: :any_skip_relocation, sonoma:         "08c2fbf15254c1fdd9a43282f89f439bbab9a79d7c1e8b58bd103d28095b6273"
    sha256 cellar: :any_skip_relocation, ventura:        "08c2fbf15254c1fdd9a43282f89f439bbab9a79d7c1e8b58bd103d28095b6273"
    sha256 cellar: :any_skip_relocation, monterey:       "08c2fbf15254c1fdd9a43282f89f439bbab9a79d7c1e8b58bd103d28095b6273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "151773aa74141532c91d59cb93eac5d29d8d561431f40dba20d6dc77ac89b52a"
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
