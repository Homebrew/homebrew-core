class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.4.tar.gz"
  sha256 "253a16dbad709e1e1065222ab0950ded6dc302ebcebba2585eed7759c7b99714"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68c80af5328d9139bc884eb7fe030682e857068f1219aa959564d20d174e5491"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23f4d518baf2dd7ec4d2e9aa27e725d4855efb8ae252e7c60b57a502282e362a"
    sha256 cellar: :any_skip_relocation, monterey:       "7b17a2f41e3a12bc59022c5d8158070430ee427e04ea4079ae6794419f1f9b2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d7069238dad4ba499ef2e726128678442ddd493166daa2f78d18f20e73469c6"
    sha256 cellar: :any_skip_relocation, catalina:       "4afa30bd072a153e406fc0e4c02b356a0878a960fcc2f1064ec1a2435ac81a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ef35b76070f834756d4a34be624350d9f08476dbe0a2f060c429e8e45b1ade"
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
