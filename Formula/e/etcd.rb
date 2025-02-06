class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.18",
      revision: "5bca08ec10d2ffcc658a5002381a3e5600d7132f"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265546020c846020cc745d61f4a4d6e89117de3d054e164d861f39d537afc09f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "265546020c846020cc745d61f4a4d6e89117de3d054e164d861f39d537afc09f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "265546020c846020cc745d61f4a4d6e89117de3d054e164d861f39d537afc09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "16c89dd0bc5af9349da8f60fb4c30f76609d68ce4b5c40491f1bafbbb9e761d1"
    sha256 cellar: :any_skip_relocation, ventura:       "16c89dd0bc5af9349da8f60fb4c30f76609d68ce4b5c40491f1bafbbb9e761d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02f1ad8f8e11ff39890864e455e15796121a21497a182577fb1cba99de8151b9"
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
