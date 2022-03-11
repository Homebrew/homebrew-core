class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.5.6.tar.gz"
  sha256 "b601b2429087252a2f5c717d2a1234dd8686d179a91112f0dbcac0503fb7fc7c"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3124dc6487e30d333c06ee3660573c9c4490aa509cc4730cf0835c0554d47b2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d39c62ac76e485d07051ab6f3866bd0c5202f794bd4f3623f25568ad9a87f72f"
    sha256 cellar: :any_skip_relocation, monterey:       "13cd8d0af7d2f4c61ebce3e9bfaefdda8f1fbec5d38b602a24770d79273e9cd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cd342cb1caa4d79fcd7b1b8c4971749ce5d7122c5017510692efee5fb983d2b"
    sha256 cellar: :any_skip_relocation, catalina:       "bbaaacfc743f3a8a250ae196fbf611085b1ebb9f5b7e812b7c0befab458800a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d314acfa68409730058b5dcc38414d89e5779f76af82c3353fe5c3698032f9b2"
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
