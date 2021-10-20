class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.7.tar.gz"
  sha256 "0dc6749a0c15a79639a183d44be630f59c7ce7c1af5a835fe0fd31c0eab4a653"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8180a55468735611fa9bee46807e48e9edac0be08dd4151c264fad845bcfa0a"
    sha256 cellar: :any_skip_relocation, big_sur:       "59263d1707e8939cd18ded9e607895abf7e8a258181ed7612328670bb0f8c60e"
    sha256 cellar: :any_skip_relocation, catalina:      "0e56d75cc6ca7214644a908565b7ae1acd48cb3bf53011813f64073b4b05b1f9"
    sha256 cellar: :any_skip_relocation, mojave:        "62f42c61ba58c8838819704e1e9de8dff131e85feb8858b483129642913498db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f215a43c84cb0e94250b4abe4ec2af993c0b633c65198121bb0382ab5e57d2f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
