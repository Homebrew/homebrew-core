class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.11",
      revision: "3b252db4f6e68c3ae3ecaa87ab1b502f46d39d6e"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc5f972e316ef6ea5534d2a41ff70a1a494ca673598bcb0eaef026dc183c8bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc5f972e316ef6ea5534d2a41ff70a1a494ca673598bcb0eaef026dc183c8bfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc5f972e316ef6ea5534d2a41ff70a1a494ca673598bcb0eaef026dc183c8bfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "a504be06b8fc24d1fbcfccbc8e21cb49bbf793b87c83a00fef20e03a66a70b11"
    sha256 cellar: :any_skip_relocation, ventura:        "a504be06b8fc24d1fbcfccbc8e21cb49bbf793b87c83a00fef20e03a66a70b11"
    sha256 cellar: :any_skip_relocation, monterey:       "a504be06b8fc24d1fbcfccbc8e21cb49bbf793b87c83a00fef20e03a66a70b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de4e1a73424502012e1cb98d77831360fd069ba4b44ebd6482c4a46dd0797e3"
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
