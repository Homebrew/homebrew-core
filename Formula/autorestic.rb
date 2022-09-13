class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.3.tar.gz"
  sha256 "2e8aea01135de1e671fa1a089da227cc8f10c1dbdb9458b5c9348f99e9e360d4"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d47f81f636baf69ba9931d713f8c6bb84ec44f2b881a3f28155ddcd8c6ade94c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0731a66c87db47cf155e08da423a46fa3c6b019aad96b84b2191cfd90aed49ff"
    sha256 cellar: :any_skip_relocation, monterey:       "8d65f2f071c8f13691a7163ba59a279dea8fc6a5c5ccda4c72526772621f5d0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "080755d384ecf39f7e76318eaca2928b65536d1f9b806d587e2d8baf483ba794"
    sha256 cellar: :any_skip_relocation, catalina:       "f4e825513f90e980789b2e6f9b06881c3c850cebb51f847c0fa384be9928f3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6dddcdd2fbbe6bef9f918380e4f4f64ec207a9b7a92c85b1d366aea2d46776a"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, "./main.go"
    generate_completions_from_executable(bin/"autorestic", "completion")
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
