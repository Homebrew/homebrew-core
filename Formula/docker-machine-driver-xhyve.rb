class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/machine-drivers/docker-machine-driver-xhyve"
  url "https://github.com/machine-drivers/docker-machine-driver-xhyve.git",
      :tag      => "v0.4.0",
      :revision => "829c0968dac18547636f3ad6aa5ef83677f48267"
  head "https://github.com/machine-drivers/docker-machine-driver-xhyve.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d64c4216f55e38b2da5ddcdda337133858c678570acd909a0f5c3910c272b8a7" => :mojave
    sha256 "53f287a301b4df97248850ef0160eda8ea804f502be7b37574f88290ce5d62e7" => :high_sierra
    sha256 "19ee4c65be0c2dcbe3b5f504e67cc0d81165164f90c007c066d9cc7b9d21cd2c" => :sierra
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
