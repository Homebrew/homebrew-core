class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.1.0.tar.gz"
  sha256 "a299ace7cb9ca1bf4f19c585cb5ac2c9d2f73970000fda77ca0cc312ab1c8b61"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63d5a4665eca314d830ffe5875b999995fd2b79fa7e610c069a13ec6a86a0856"
    sha256 cellar: :any_skip_relocation, big_sur:       "3186dfb8d338205de412465bf2b133e85adca6db367fafc2eb2b2857effba995"
    sha256 cellar: :any_skip_relocation, catalina:      "e0bc7621e7a2ea7c40605ecbab5f17188be80396d457b032c591b6317e1473f2"
    sha256 cellar: :any_skip_relocation, mojave:        "219e5017028d6f2e9d5cdf05818574b653ee7c33a5ed15ff279462c32f0883c2"
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
