class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "a3174c795938b9d70a6af99d90c71083c228d82fc3c6a9961f8315ac12860f37"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b14254b069022062ee452312c7ffe63f394282aac13a2659a5f9cdb078cfa06b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16ba076129c9a7b44ea54dfed40950ee04cf58ab9d40b86eb3a7ae27b703e8a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e5fc6e05161600edb7155793f98b332307f1c12b709f9b83668f19f51b0036"
    sha256 cellar: :any_skip_relocation, sonoma:         "52e186bbd9165f7222210a47d35aaeeac6b614931adcc32ffd5a8f9f30b7cf47"
    sha256 cellar: :any_skip_relocation, ventura:        "62b70ec11e677c3ec278db88eba44c9f99bc6a0bd11cc032d8437a7478856688"
    sha256 cellar: :any_skip_relocation, monterey:       "a594666a8ab78a1eb9a10019121b2467b774b44f8e4955061d3dc66bda652ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34df12edbfd6d392c6d6cfa171e3df8bd3b814f8df8ed5c613af88d9b27a8062"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./main.go"
    generate_completions_from_executable(bin/"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2

    (testpath/".autorestic.yml").write config.to_yaml
    (testpath/"repo"/"test.txt").write("This is a testfile")

    system bin/"autorestic", "check"
    system bin/"autorestic", "backup", "-a"
    system bin/"autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
