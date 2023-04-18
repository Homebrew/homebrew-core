class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet.git",
      tag:      "v1.0.0",
      revision: "b8127afc06e3e41089a7fc9c3d7d80c9925f4dab"
  license "Apache-2.0"
  head "https://github.com/coreos/fleet.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d95d7c2a535214d3e02819916101e64fd1ecfd17a09a33fcc270696e08766d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bb493ec565f24cc16ae33f23f860cb179047a4d379474c2c1e1730fd2b07ae7"
    sha256 cellar: :any_skip_relocation, monterey:       "e77b6b66846ae13494dd3f8a950b8650c3ae0847b1f3e439ce216c8aab3275a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "db133bc31ff2a813dfaf6b5faa7d41c892dd91803f5612540a09b58c7c81d783"
    sha256 cellar: :any_skip_relocation, catalina:       "69f1d75544203e04ea3fba75c639ebbdfa564f0cbdea53f62bfb2f8f253bdf60"
    sha256 cellar: :any_skip_relocation, mojave:         "a8fa7b4e9479073b568a5e1325d7d56708e28cbc921df09698cc671dc939b258"
    sha256 cellar: :any_skip_relocation, high_sierra:    "578bc15de6d87d53165ff70805388b41388f01d10a7c5d809fafd46c4d9040aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5572247273e727544512f619016572c64f0694328b20f94d00897824512809f4"
  end

  # "CoreOS recommends Kubernetes for all clustering needs":
  # https://coreos.com/blog/migrating-from-fleet-to-kubernetes.html
  disable! date: "2022-07-31", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fleetctl --version")
  end
end
