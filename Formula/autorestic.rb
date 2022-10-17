class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.4.tar.gz"
  sha256 "253a16dbad709e1e1065222ab0950ded6dc302ebcebba2585eed7759c7b99714"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69042516e2faf12992d61291178d29e478d14bbb83c3d28f02c0a82f10d3207b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "668f7201781a5f35e59c70a3bcd842becd59d66f023a95524908ec32a178b06f"
    sha256 cellar: :any_skip_relocation, monterey:       "dcd01244517b8ed82249bfd0183aa86d09a866a18fc55ff5e5a7b54d7585d232"
    sha256 cellar: :any_skip_relocation, big_sur:        "93ecadc8564c82f953f8798992c2f79069db31aadd386fbaf0d5cf5df08c160c"
    sha256 cellar: :any_skip_relocation, catalina:       "e57c37ab4e69a676c31bf705b01f7e4ad4d11de6e7bc7923024b478ab149c7d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32ebf61213d533f9b7d4270bd9eabc63bcfe5e120f7f5be64d8c3c61f7dc4381"
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
