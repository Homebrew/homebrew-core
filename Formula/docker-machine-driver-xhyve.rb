class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/machine-drivers/docker-machine-driver-xhyve"
  url "https://github.com/machine-drivers/docker-machine-driver-xhyve.git",
      :tag      => "v0.3.3",
      :revision => "7d92f74a8b9825e55ee5088b8bfa93b042badc47"
  revision 1
  head "https://github.com/machine-drivers/docker-machine-driver-xhyve.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "7eeb3489a188327643e61883a01ff2c45d07dd03ce63c64ccc74e1254816fc53" => :mojave
    sha256 "0564764571c40c98bfc1a487d14c6c9c1306f9ce989fdb02ec03a4c192dc72b7" => :high_sierra
    sha256 "6aeca9446ca593ba8d1b417f71174937c71c0341f1d9427d7b5b6e4147dd0c62" => :sierra
  end

  depends_on "go" => :build
  depends_on "docker-machine"
  depends_on :macos => :yosemite

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_root = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    build_tags = "lib9p"

    cd build_root do
      git_hash = `git rev-parse --short HEAD --quiet`.chomp
      git_hash = "HEAD-#{git_hash}" if build.head?

      go_ldflags = "-w -s -X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'"
      ENV["GO_LDFLAGS"] = go_ldflags
      ENV["GO_BUILD_TAGS"] = build_tags

      system "make", "build", "CC=#{ENV.cc}"

      bin.install "bin/docker-machine-driver-xhyve"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute
        sudo chown root:wheel #{opt_prefix}/bin/docker-machine-driver-xhyve
        sudo chmod u+s #{opt_prefix}/bin/docker-machine-driver-xhyve
  EOS
  end

  test do
    assert_match "xhyve-memory-size",
    shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver xhyve -h")
  end
end
