class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.0.9.tar.gz"
  sha256 "4795e9797fb89361c8108ff8196b90690f85f6744947bd7863ebbe995a0440ca"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5244ac8cbd04b7cc52e75e8edbf114db12155ff982de48c4ba14e65b38793220"
    sha256 cellar: :any_skip_relocation, big_sur:       "79037e1da3f7666e3e50c6375fdad8166c795a9c036efc3420c22ba70e28f733"
    sha256 cellar: :any_skip_relocation, catalina:      "c2a41089b5742f9d5d5b934c14542406eac30e2cb9944e7fb554feb60a37f1ec"
    sha256 cellar: :any_skip_relocation, mojave:        "7f7da8655489990e40bd36239bd3cb00c0cd7ef1c94d2159177a2a56d404907e"
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
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/"test.txt"
  end
end
