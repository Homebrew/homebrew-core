class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.5.6.tar.gz"
  sha256 "b601b2429087252a2f5c717d2a1234dd8686d179a91112f0dbcac0503fb7fc7c"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9149f78df132f1b6cdf1845ace2e8c153510537f2a8a0225583235c71afbfce9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d06a5673e2936678462f5bf79749970589112adc008b927217398f6e84e9c72"
    sha256 cellar: :any_skip_relocation, monterey:       "fef9903b0a5da4cbd231f873e8fb37bbfbaf4cae2c09c9536b6749fecb7f7df9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b96bc9e4756de20d2fe58979dacdc096750a4cb97fccef6dbedc4359871ea09"
    sha256 cellar: :any_skip_relocation, catalina:       "d3ad6905edd8dc2fb4a4347035708d13c801e2f04f12c02ef9a6bc492f643930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b28400b46ac3def9d3d7bf4c59816d5b8943fdc173aa0be6fab68d7a424843"
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
