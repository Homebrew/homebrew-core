class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.2",
      revision: "99018a77bea9a9d29962e5169876c64e02739c52"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a95889d8e156f62363c997c53c46da5c11474cd7cf2bedeb1f110bd74726a64f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53f192e95956037b10b49c1c07f5ee9662cb38c4690f887168ec83821b55896c"
    sha256 cellar: :any_skip_relocation, monterey:       "f85a6ed302aa8d28af4321579cb665fdbc03a488ecd987180b9d010a66fcdbd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d70343700b913267ed87675676b1867aae73506feff90674d255986b3c1d80a"
    sha256 cellar: :any_skip_relocation, catalina:       "4af1f41b507cb89e1cc3497de0cf5751b86cc8a5715c69b6a81537376f5ecf72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baba042d65b933023e0d2e9a335ddb2f31712edfcf5d20f9969a4b46e4225930"
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
