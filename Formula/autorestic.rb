class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.4.1.tar.gz"
  sha256 "889a15beac1c1bc1e50c437a493501e7f37afbacf4f23edf9e8d89feef547c59"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ca6a29c7f0845ff92849e54c0181cbb45dc245118bb7d13cebb90b822e68d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be37f38665a25e1e5c518f56a2cb7c4bc45c4afbb5f8413206c22bae78ac31d5"
    sha256 cellar: :any_skip_relocation, monterey:       "9ab1d52f87bb836c73ee04dc840b92801be0caeba4662912e1f7048fc1f93b08"
    sha256 cellar: :any_skip_relocation, big_sur:        "71a956e1368a785277eabcf58d6b5ed8e81484bfa51061cdcb10884751f9a2da"
    sha256 cellar: :any_skip_relocation, catalina:       "308925c1eaa777b54af81c4d810348271abc3f1843c7dae00d3d54e2e2ddaaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31744356ee2fef93a98e483889de3dc72cd41da9e53ec5bf20e348d85372bfaf"
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
