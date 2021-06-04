class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.1.1.tar.gz"
  sha256 "f1bbc4b64cf5a2ee2e738500109867e3dc77a2190cf847d18ceffc7d2831053b"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cc1a51fdcc1e8ce9c6fbfbadc14aa97c2b3fc28907f9f23633fb4fc16bf668c"
    sha256 cellar: :any_skip_relocation, big_sur:       "276d5de8b1fbcffb06aa1748d17771d94939b431bbe1748ccb8d932aac9c74d3"
    sha256 cellar: :any_skip_relocation, catalina:      "dbb8deeb7b735202730220f2edfa4ce019ba52d07be44e80ce68351dc56cb96e"
    sha256 cellar: :any_skip_relocation, mojave:        "ddc1d2cf89b9aeca14b66e3368b915224ff765ba6fba894e477acef29603ee74"
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
