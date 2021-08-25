class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.2.0.tar.gz"
  sha256 "394f708ee77b71ea9d337dc265fd3436ad0adcb85e6c6da9ab70d6c49e32734b"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c76d60fdbe620a6520dc9877c500592439d8990abbabfb371ada96db062e656"
    sha256 cellar: :any_skip_relocation, big_sur:       "be1358fa49ae197d78d0880f2125e9c9e07adcdec4089524e0e05611e6395df7"
    sha256 cellar: :any_skip_relocation, catalina:      "6f37e8a19a8d8425353a6461b6cdee4b7c804d9c86c191e71e552b79e4f4f456"
    sha256 cellar: :any_skip_relocation, mojave:        "842f9a9f2845393a5e8460d468990bc0ad970880bb6e2a25a1d84b9d6bdc2cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18fff0e0e3c31e70b22379cded4ef1848013e97d957e11e60424d03442423d69"
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
