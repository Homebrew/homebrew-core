class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.7.tar.gz"
  sha256 "f2c38729882e7d0529347ab115e7ce068f6062677a63c92eb4bd0efc1ae67cbb"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "038a4cc1f761cdb7487b3f23344229c8ded9cf9fdb40a2e9aaa4b5854b76962b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "038a4cc1f761cdb7487b3f23344229c8ded9cf9fdb40a2e9aaa4b5854b76962b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "038a4cc1f761cdb7487b3f23344229c8ded9cf9fdb40a2e9aaa4b5854b76962b"
    sha256 cellar: :any_skip_relocation, ventura:        "00491c3ed12f5f38a3622879a06d3d754a5b666967b0fc96955cc014ba9afd8f"
    sha256 cellar: :any_skip_relocation, monterey:       "00491c3ed12f5f38a3622879a06d3d754a5b666967b0fc96955cc014ba9afd8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "00491c3ed12f5f38a3622879a06d3d754a5b666967b0fc96955cc014ba9afd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c7e82dbdcbb94061ec566cfea21785bfeec10c4ae3fbb096bba12b407cecbaf"
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
