class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jakedeichert/mask/archive/v0.9.0.tar.gz"
  sha256 "7594a328fe1729fb3b49dbbba07a469689c58850fbeb77d94369d83713e37b7a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f36dcc50a822da9a3facf9878157cb43bbf2c5ba44a56bdd87759d0ebe5d534" => :catalina
    sha256 "b8a0c2921b7641e36a8ce92523ba5a89aa6558b1e9089095eee102a734360bf3" => :mojave
    sha256 "5445d94b7efe4a65c8d9c5332e951aace2b9bc88564a3e4f714c38d53a4b4961" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
