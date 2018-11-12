class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve.git",
      :tag      => "v0.3.3",
      :revision => "7d92f74a8b9825e55ee5088b8bfa93b042badc47"
  revision 1
  head "https://github.com/zchee/docker-machine-driver-xhyve.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dd1c4c4e723dddd4707a15ae1b82e689dea0754a1ee1c02b090e0cd7230a794" => :mojave
    sha256 "bac6844c0bb62f1663b694496c49cf67104375efcdfef452c07efd8f30c37d39" => :high_sierra
    sha256 "263f1beca8cbefe901fbf2d8ce47e71c0a19ba3ea1cf258b6b04ff52784f0354" => :sierra
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
