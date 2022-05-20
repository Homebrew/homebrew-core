class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.1.tar.gz"
  sha256 "89ffb11c14eb02bcc66427517a43a42a7e73ea359b579b8c2047c95ce5f9a8d8"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a82d14065048ff87219e943ebf89f0cd44b48638463164b2e18396797301693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d09ba325c8d35778a2d3da2dac787209e990af3b4d9c9e99699b13867dcd2d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "4bfe8dbce83595bcab7a29d21b94c23133664691b34ebb08ed265103bad0c135"
    sha256 cellar: :any_skip_relocation, big_sur:        "72c0f9a981446a371e4d66c77b8c46d07e376c5c063c9b305c21cca20267f4fa"
    sha256 cellar: :any_skip_relocation, catalina:       "1e9601d092965a616228cc932ed0f0d594bf094d9a46e3b3d632ab96b7269147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c799dc957a9e3498292442f66c7153d938f2ee0869cd966c350f5d779e5de97c"
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
