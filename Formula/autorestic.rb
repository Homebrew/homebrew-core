class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.5.1.tar.gz"
  sha256 "f0ad322b51408d5a47435923b9cc4858c4ba030bc0e7ad192ec40c5e7cc80e67"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552199bf5cbb62d1b449959202cbeb96432074fd4e006fa919afe5923dcaf3e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28d3b47d0c8710949ef2d1c758078b065e9fb7f215b81438defe564cd6228c08"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7d1cc3b3ef65a561dd6792e7b946c8b194a71753d9958c36ea29642bb3dc37"
    sha256 cellar: :any_skip_relocation, big_sur:        "118d6e0abe7588d7ca40eb3744f4b6bf518b9652ce510ca778dbff2fd703dff5"
    sha256 cellar: :any_skip_relocation, catalina:       "6c47c02a5e21d3754fc8960660328982f4d52b0fcbc7d0396d32e30faace9086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf42e1779cbb641919354a277022b015aff2be2d9564bf668b4afe0c892d3d29"
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
