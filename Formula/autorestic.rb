class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.5.7.tar.gz"
  sha256 "8a11b56797163f219a55a9e5b61fa0d91d4eff92b9414f4f180ace89920136a1"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da6a80580f2c7769b8b61d80ea0704b849f018dd7c703efe230f47d9530bd95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a987e71ca81f080627ab226d271a8bb59f9b6283e0c7e7aab79953ab398b328"
    sha256 cellar: :any_skip_relocation, monterey:       "dfd48756037e66c555b2e200f7f19e79867249b43efb09847c4fcb5a2cce9949"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0f86d6fc4f05098fe93c3d74dae04aaaf3c3b2c058ab282f2e0032248cc9057"
    sha256 cellar: :any_skip_relocation, catalina:       "f4d73fc95ec3b9ca34beb32ddec721681b9eb46434e42b4a727694c39bef5814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4941a75b88187d52bca80eccbffb1d132d052b98cdf8ed93ae5c442f99defea"
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
    config["version"] = 2
    File.write(testpath/".autorestic.yml", config.to_yaml)
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
