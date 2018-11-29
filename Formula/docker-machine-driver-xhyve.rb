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
    rebuild 1
    sha256 "39683691a1d424c846d189ff59a9c440ea02da4a67fb116653d5e595b0a7f9f5" => :mojave
    sha256 "e15d04d93aa564ec6eef37b15759b111784686229d3ba1dc71c2b3cb6791d48c" => :high_sierra
    sha256 "9f60bccca6ae7519af11eaabe2124d2a5e5c9e5295e0296aa7152162e0b8223a" => :sierra
  end

  depends_on "go" => :build
  depends_on :macos => :yosemite
  depends_on "docker-machine" => :recommended

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
