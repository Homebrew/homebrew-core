class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.7.tar.gz"
  sha256 "f2c38729882e7d0529347ab115e7ce068f6062677a63c92eb4bd0efc1ae67cbb"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45820b7b08647c3cfdce913ad07681b7332a3b58807632b76da024101cdbbc54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45820b7b08647c3cfdce913ad07681b7332a3b58807632b76da024101cdbbc54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45820b7b08647c3cfdce913ad07681b7332a3b58807632b76da024101cdbbc54"
    sha256 cellar: :any_skip_relocation, ventura:        "32f50e602661bb6294920c18dc92468cced32cf2ac7b4cb1183a7ce7dde87c2d"
    sha256 cellar: :any_skip_relocation, monterey:       "32f50e602661bb6294920c18dc92468cced32cf2ac7b4cb1183a7ce7dde87c2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f50e602661bb6294920c18dc92468cced32cf2ac7b4cb1183a7ce7dde87c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca4421de1bc7ff17d52fdcf4f378231fd6dab72d01f41e0bf5c6b2bc655024a"
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
