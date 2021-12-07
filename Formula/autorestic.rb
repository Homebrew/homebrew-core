class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.5.1.tar.gz"
  sha256 "f0ad322b51408d5a47435923b9cc4858c4ba030bc0e7ad192ec40c5e7cc80e67"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2227c50c02d248f27e76e3f7f22288888c1f9fe6e7ac9b200a6e429409b5d819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1436abb1a262becc7da8227085d03d0b5dd85468ebe096ab3015c6325a2af8cb"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec397b9d4ed003121057f114ec2fe5f4c0f7fa0448ce927e3bdba9bcfc25072"
    sha256 cellar: :any_skip_relocation, big_sur:        "54909863e41204aebc7a1f0cbf6e298a2eb548584d36774815c23972232ad8cc"
    sha256 cellar: :any_skip_relocation, catalina:       "0361c1253edbcbeb5f239ab5fbe2b5e4d11f8229948cd4e31009882ac37df406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a0f7bbd160ed3d12961a46747039c3578ddd9826c20914980d52fb4638179c"
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
    File.open(testpath/".autorestic.yml", "w") { |file| file.write(config.to_yaml) }
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
