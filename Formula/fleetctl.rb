class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet.git",
      tag:      "v1.0.0",
      revision: "b8127afc06e3e41089a7fc9c3d7d80c9925f4dab"
  license "Apache-2.0"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "db133bc31ff2a813dfaf6b5faa7d41c892dd91803f5612540a09b58c7c81d783" => :big_sur
    sha256 "69f1d75544203e04ea3fba75c639ebbdfa564f0cbdea53f62bfb2f8f253bdf60" => :catalina
    sha256 "a8fa7b4e9479073b568a5e1325d7d56708e28cbc921df09698cc671dc939b258" => :mojave
    sha256 "578bc15de6d87d53165ff70805388b41388f01d10a7c5d809fafd46c4d9040aa" => :high_sierra
  end

  deprecate! date: "2020-11-15", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fleetctl --version")
  end
end
