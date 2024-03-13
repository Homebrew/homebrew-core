class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "2bee19866dd365cddf306ab8fddceacac7ef11162da90b355d44f6ae9943350c"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d541e809577fd8a4184b9cbb630d3eeefaadf17ef62294a499f44af05f7e0a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "631a5753766d572ed9a5bf53bf7858841131ce8727d4e9e46330c7c03c472153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ecf5cabcf3ac802d3f105815eb3039b9c9a5a9a425924df0118cab342b8c96"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ea531dbc2a68676c83f482c82b30eceb0c4597e35f402668c1c109a27c70993"
    sha256 cellar: :any_skip_relocation, ventura:        "d03c7487b8d946362b4dafc790ccbd3adccbfd2277391bc52d756e8cd88faa7e"
    sha256 cellar: :any_skip_relocation, monterey:       "5c192815f29dab34aecad2d087eff9264649ca44065e655b5340751915991f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad47371feb780bed56cbab307fde6719556ee10bf6297e277d45dd860a77203b"
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
