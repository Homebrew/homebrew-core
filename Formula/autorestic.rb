class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.2.0.tar.gz"
  sha256 "394f708ee77b71ea9d337dc265fd3436ad0adcb85e6c6da9ab70d6c49e32734b"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9187de5a27f8fa2470dd1ddc78c6ffe93dfab21b7fb84643b06a19d6a0fb4239"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9e20ede08dd2a7ad93b2c96189a3b052207db82654711d0c5909f22d4502802"
    sha256 cellar: :any_skip_relocation, catalina:      "ee2966ee5111d262a073aa8af24a6cd751350561c15f21bdb4213a557450f1c2"
    sha256 cellar: :any_skip_relocation, mojave:        "cc4b3027ef2546d01a4ef9ac5f62ebbdcaeff299583679a4d699f44308540130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9083fda98e8a8c522619e3b2c4a88baf79c8a426f156ea439d6bac92c5a97d"
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
