class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "2bee19866dd365cddf306ab8fddceacac7ef11162da90b355d44f6ae9943350c"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21d84be529b93e0d91ab301d50f3b238f0cbcb337a91d55e778338b25532ec2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3c887b89d6e111069bc94d3b77a283e45a634654015c821ec7971f431eed999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5efe71592ba1fb6831e84df00e02e4b197a7deaf2318ae50af51e63b6adf039"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a9dc937b2e51a0fffd2f092223ef8e0983ab92fa6a3fe07f540deaa39bd8dfd"
    sha256 cellar: :any_skip_relocation, ventura:        "f43e77974777a51ab5f503a55188dc7bafff09c99c4b3648353c1198bb87cc49"
    sha256 cellar: :any_skip_relocation, monterey:       "fcbaf7a8f4cc55bce7f158c9e6a0df06b8e1d4129b48bfda2b45f683a37feee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2616c3238463f80d37af128fb763f65bcb0a121850bb5020f2b6174dcede03c7"
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
