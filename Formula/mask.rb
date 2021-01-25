class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jakedeichert/mask/archive/v0.10.0.tar.gz"
  sha256 "264ebdde63794046b2f79d3a3d87873563a75ef7bcc2ddc3c962670b313a4bf8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "95563975f0b87651a58c01845c098b93d6d0f7dfed889bebf4364e8fdfe2ffa6" => :big_sur
    sha256 "f41f306180943b68451ecbdafacab47f497ccfa00d95baf592c58d0068ee6295" => :arm64_big_sur
    sha256 "80a869d6a62e065235ca7057e1a0df2b5045232cd897bfc5ee7b924098d8ac99" => :catalina
    sha256 "a4caf4f75c456b398325a2dc24d4a9b7681559fc53a55bac2b590a179bc5cde3" => :mojave
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
