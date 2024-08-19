class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "847a661bcf8bfdf282eca0dfd677293ad932726d357899c15a85b9238c4ea3da"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32716f3a9631fead881d9023ec8ae72d02cc7d1ae86161f0c272c582bdd039bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0eb52434a00aa0b8dd179167d7221d623ee170f4000027aacced28185049970"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e80b7026aea2819adf18517a8931fa0d9536f05b9be25894832ca2e7eda368ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "36552e1e7c62f7a00de94e0eb06944fa6609a352d375285cf126433270af0155"
    sha256 cellar: :any_skip_relocation, ventura:        "1baee5ddb9f60f8c88d89e07302a6df36120f3fc789ed3bd54213348bfd526b7"
    sha256 cellar: :any_skip_relocation, monterey:       "e6a76092098c3f39157f6b7881ea4f4aee5eeb114d39076c3bd4ccdc0002292b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e5336efc10cb4933520ba4667969fde194d8fac1c089f5dce80d458128c812c"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./main.go"
    generate_completions_from_executable(bin/"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2

    (testpath/".autorestic.yml").write config.to_yaml
    (testpath/"repo"/"test.txt").write("This is a testfile")

    system bin/"autorestic", "check"
    system bin/"autorestic", "backup", "-a"
    system bin/"autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
