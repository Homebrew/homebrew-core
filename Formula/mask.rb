class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jakedeichert/mask/archive/v0.10.0.tar.gz"
  sha256 "264ebdde63794046b2f79d3a3d87873563a75ef7bcc2ddc3c962670b313a4bf8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "46561cab979648d082e4c2c591b0b8db89d5bffaa440b41460177fd2716ccef3" => :big_sur
    sha256 "37bc68cf85d0cd1c87c95be13666f00eee7e3cb8b287322d082e5703b01d523a" => :arm64_big_sur
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
