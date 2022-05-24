class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.4.2.tar.gz"
  sha256 "4b3c092b405d9bd50b49d1aee1c3fa284445812b3fcfae95989a0dd2b75a25c0"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72944d7b61a051c3d7bb54c1fb5e0f11e7c079dde00dfe62a45fc23c819aebfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72944d7b61a051c3d7bb54c1fb5e0f11e7c079dde00dfe62a45fc23c819aebfb"
    sha256 cellar: :any_skip_relocation, monterey:       "7b06f99a3af92cc9fbe73d1ce39868bc3b864e32dbcd4f2f332ef1541de2a1fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b06f99a3af92cc9fbe73d1ce39868bc3b864e32dbcd4f2f332ef1541de2a1fa"
    sha256 cellar: :any_skip_relocation, catalina:       "7b06f99a3af92cc9fbe73d1ce39868bc3b864e32dbcd4f2f332ef1541de2a1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3fd8cafbe6cf7216c82ba5fc49933094e76b4170932634b463524fd95c36b50"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gocloc"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_equal "{\"languages\":[{\"name\":\"C\",\"files\":1,\"code\":4,\"comment\":0," \
                 "\"blank\":0}],\"total\":{\"files\":1,\"code\":4,\"comment\":0,\"blank\":0}}",
                 shell_output("#{bin}/gocloc --output-type=json .")
  end
end
