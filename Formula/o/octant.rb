class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.25.1",
      revision: "f16cbb951905f1f8549469dfc116ca16cf679d46"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a67de7df80e394aab071351c5daed2bebc29e9e62e98564f6cbdd5d82d177395"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15cb0eed642b761f16c0b15af9cd2840abccdd01a9b396b2fc562285bf882c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "788d92a1207ad2adc9c6646feba0dd95fb0fc676bd847d712655b7cf90649a5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051bd42c57e7e0b2bee8654780c4e933d8573c5be2fa9d2b56cc2dad887a731b"
    sha256 cellar: :any_skip_relocation, ventura:        "26f041666fd4f320f045d6d2b15e5e5e49cb2bec9597ba0ff818cb59513fa4e1"
    sha256 cellar: :any_skip_relocation, monterey:       "c3727d1b1e5bc15b1bf9871fea589b463f035cb92ad9898a00cffb5752e9a55e"
    sha256 cellar: :any_skip_relocation, big_sur:        "71c030c4adb0923f6b1c6956aa7888e5a89382bf32fb9139423867b3ae2a5b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df389cca7e8d7586332ee36bf529a8e6aaf70f94acd2ba567c99445e8874bd3"
  end

  # "VMware has ended active development of this project, this repository
  # will no longer be updated."
  disable! date: "2024-02-01", because: :repo_archived

  depends_on "go" => :build
  depends_on "node@14" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["GOFLAGS"] = "-mod=vendor"

    # Work around build error: "npm ERR! Invalid Version: ^3.0.8"
    # Issue is due to `npm-force-resolutions` not working with
    # npm>=8.6, which is used in node>=16 formulae.
    #
    # PR ref: https://github.com/vmware-tanzu/octant/pull/3311
    # Issue ref: https://github.com/vmware-tanzu/octant/issues/3329
    # Issue ref: https://github.com/rogeriochaves/npm-force-resolutions/issues/56
    ENV.prepend_path "PATH", Formula["node@14"].opt_bin
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
    end

    system "go", "run", "build.go", "go-install"
    system "go", "run", "build.go", "web-build"

    ldflags = ["-X main.version=#{version}",
               "-X main.gitCommit=#{Utils.git_head}",
               "-X main.buildTime=#{time.iso8601}"].join(" ")

    tags = "embedded exclude_graphdriver_devicemapper exclude_graphdriver_btrfs containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags:),
           "-tags", tags, "-v", "./cmd/octant"

    generate_completions_from_executable(bin/"octant", "completion")
  end

  test do
    fork do
      exec bin/"octant", "--kubeconfig", testpath/"config", "--disable-open-browser"
    end
    sleep 5

    output = shell_output("curl -s http://localhost:7777")
    assert_match "<title>Octant</title>", output, "Octant did not start"
    assert_match version.to_s, shell_output("#{bin}/octant version")
  end
end
