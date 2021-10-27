class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.3.0.tar.gz"
  sha256 "be7ba9d4569047a7c2df6d07e6e73e4f12f843b2054316c51bac5ed33ff150ce"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "444363638492e061fe8a5f7c025c1bdc380234de77dfe4e198715c9339e40ae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "984e7b1cacb3d3681542c456dfadd636e97ce6c9e6c7fb57c17ddc572181f279"
    sha256 cellar: :any_skip_relocation, monterey:       "163fe3de2a115117b49744cfe853ab668df153c8511a3c43ba023e32fc46724b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b71c3459ec007b6a847ba4fd731edce74665d55b7c0f72d0a7c60ddbc7a9a9e6"
    sha256 cellar: :any_skip_relocation, catalina:       "6aa4994d633514cec4eba16f528c5e7aae4bbca11e1d2b821715776fa2873dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58577a7c45501bdfeb6097845ebc452297af2da7734b285258b63227cc57b82d"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, "./main.go"
    (bash_completion/"autorestic").write Utils.safe_popen_read("#{bin}/autorestic", "completion", "bash")
    (zsh_completion/"_autorestic").write Utils.safe_popen_read("#{bin}/autorestic", "completion", "zsh")
    (fish_completion/"autorestic.fish").write Utils.safe_popen_read("#{bin}/autorestic", "completion", "fish")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    File.open(testpath/".autorestic.yml", "w") { |file| file.write(config.to_yaml) }
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/"test.txt"
  end
end
