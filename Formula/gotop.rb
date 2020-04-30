class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v3.5.2.tar.gz"
  sha256 "d175d370491c1d1b98c8cd1015674f5cfc04d3dbe6ea4a528b641698f0fafb34"

  bottle do
    cellar :any_skip_relocation
    sha256 "64c1dbdac093d37353e400b5ee47a9e2bb2268bf26a11c1853c331da349c230e" => :catalina
    sha256 "dcca12e1f88c8f8b835257839b38930203fa9d6df475b672ad1a65f99bf34855" => :mojave
    sha256 "20a37aeed1acf7a6a99c2ec63783a65e1813c92811e042c21ddea3d5dd18b132" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gotop"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gotop --version").chomp
  end
end
