class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/machine-drivers/docker-machine-driver-xhyve"
  url "https://github.com/machine-drivers/docker-machine-driver-xhyve.git",
      tag:      "v0.4.0",
      revision: "829c0968dac18547636f3ad6aa5ef83677f48267"
  license "BSD-3-Clause"
  head "https://github.com/machine-drivers/docker-machine-driver-xhyve.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:    "5c0cf9c40831d43e094ec493d9c4598019f7c9a9b3daabce0369777fa17f77aa"
    sha256 cellar: :any_skip_relocation, mojave:      "b7e9879c8c5c734da5bd83ae00496dc26dcf8133e354662e7b6a8846bfbfc989"
    sha256 cellar: :any_skip_relocation, high_sierra: "282868271a1e504ca8643bb6507eb2f99f8f8703d64050886e00175182b35668"
  end

  # xhyve is no longer used by Docker, replaced by hyperkit
  disable! date: "2022-07-31", because: :does_not_build

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install \
      Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_root = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    build_tags = "lib9p"

    cd build_root do
      git_hash = Utils.git_short_head
      git_hash = "HEAD-#{git_hash}" if build.head?

      go_ldflags = "-w -s -X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'"
      ENV["GO_LDFLAGS"] = go_ldflags
      ENV["GO_BUILD_TAGS"] = build_tags

      system "make", "build", "CC=#{ENV.cc}"

      bin.install "bin/docker-machine-driver-xhyve"
      prefix.install_metafiles
    end
  end

  def caveats
    <<~EOS
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
