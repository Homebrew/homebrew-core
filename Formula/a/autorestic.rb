class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "e57bbc045edee4aabd850da2e61da9c18a6d12bd323866be1eb3edca4709b363"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b2ea517f5dcd33825bb1c27c3d427a772d7856f4e86e684f22ab9de77f65222"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff1f15e047c99f33bbbf417069d31f480f665897eb8a059493b535490d9bcdb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1d217768c960da4daadbe1878631a0c374535906ea59083053c23d10a356c6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "303c81e6535980fbfb9dc298d046edd4244175bb2bd57c6a7dbe4bc8917151d9"
    sha256 cellar: :any_skip_relocation, ventura:        "147db7df17660bddf0efba49ea04d1289f6db19d157c6f4beb4a4ac9c39f7eae"
    sha256 cellar: :any_skip_relocation, monterey:       "71312f574ce4a6ef0af94938b72b79f093913bc30bab080d05d08f5e1954da21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0692eb41431ecb8f4479d95261481256f92552c2e68cc93364d3b41572a76f1"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, "./main.go"
    generate_completions_from_executable(bin/"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2
    File.write(testpath/".autorestic.yml", config.to_yaml)
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
