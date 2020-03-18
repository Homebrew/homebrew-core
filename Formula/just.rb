class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.10.tar.gz"
  sha256 "ae8219cecad107c296e41b486e1966f0c19ae3222fb29d3738aeaa3c34e4a431"

  bottle do
    cellar :any_skip_relocation
    sha256 "68540657a8a367784b2618c99e49031b471b76f442eb1f2ffd8908701b770462" => :catalina
    sha256 "e0b3d06a1f4076431c63e8115b02eb5db7b6db89d6f7e6c7af6af03ae2c76d93" => :mojave
    sha256 "cdc95df17fa3dc216df56e802cb87a6009faa57358b5a9521dd0df6f02831392" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
