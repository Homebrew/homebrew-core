class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.5.8.tar.gz"
  sha256 "ca132142d2b682002d59232c390df7f426493c01f377cf33bd8712de0c2e4bf9"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ff780c0b3c099846b801337abd2a6d840d5b789e436081a4ca140e491f71076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5fc1340227eef1fe42d0a40b751c132bcbffefe95327eadecc944bfb972f531"
    sha256 cellar: :any_skip_relocation, monterey:       "198eef0c6194a0451e86594869a9517166737470b174f86e5d8ad75a0c549c40"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6417f37236a48311b9385702ee472c5134cf73d413ba2b6bcf73e087b4759ef"
    sha256 cellar: :any_skip_relocation, catalina:       "0fd58dd1a88a7bc9d3ffbad3eff5849b19753c828d2bb22469669cf0f04cc99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5a50264ee2c2b6685b86f75f0e2fc17fbdda908963e5dec3affd5fed3e30f6"
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
