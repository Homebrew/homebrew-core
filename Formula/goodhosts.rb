class Goodhosts < Formula
  desc "Simple hosts file management in a Go cli"
  homepage "https://github.com/goodhosts/cli"
  url "https://github.com/goodhosts/cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "6c956ffb6b9c838cd8e6dfe72b9e60fd8b21c674e57a0ad2fced7e23b042ce60"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"goodhosts", "."
  end

  test do
    (testpath/"hosts").write <<~EOS
      127.0.0.1 localhost
    EOS

    system "goodhosts", "-f", testpath/"hosts", "a", "127.0.0.1", "localhost", "test.localhost"
    assert_equal "127.0.0.1 localhost test.localhost\n", shell_output("cat #{testpath}/hosts")
  end
end
