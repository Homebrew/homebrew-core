class Mapscii < Formula
  desc "Whole World In Your Console"
  homepage "https://github.com/rastapasta/mapscii"
  url "https://registry.npmjs.org/mapscii/-/mapscii-0.3.1.tgz"
  sha256 "21f18b687975f1decef998664ef6d292cf2379d9e4308a5b4cbb66af240341b3"
  license "MIT"

  bottle do
    manifest_sha256 "b5d37e1aefee3f7e4ed9f9ab2a761473661191508bd731af9d142a36263bfe96"
    sha256 cellar: :any_skip_relocation, all: "5f4eaa8d74d98faad1c1423bb6f7c54efe68e47cd932192fdea23cca28cfb831"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output_log = testpath/"output.log"
    with_test_process(bin/"mapscii", [:out, :err] => output_log.to_s) do
      sleep 5
      assert_match "Failed to start MapSCII", output_log.read
    end
  end
end
