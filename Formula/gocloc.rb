class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.4.3.tar.gz"
  sha256 "b96a3da5c5ec084107f29c339414774a7bf0c3c71e41ae5101cc48824ab9ecb2"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b5d998cf6afdf0235077ada50616b7e1da6c66f5f6d16cac584e78e18d4045c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e01032fe7b3eba5c8fb7f4d22ab3bf0c1a9e122b464c73eef0d8fb53daf3064"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e01032fe7b3eba5c8fb7f4d22ab3bf0c1a9e122b464c73eef0d8fb53daf3064"
    sha256 cellar: :any_skip_relocation, ventura:        "87cde88d2238c4c732487f6582dd1741a1db2c6032cf70a5089b9f5ddfa39fc5"
    sha256 cellar: :any_skip_relocation, monterey:       "71eaf256d9a9108ef7b2ee147b8c71aae25c4304897744b57eaec70ccd3d2911"
    sha256 cellar: :any_skip_relocation, big_sur:        "71eaf256d9a9108ef7b2ee147b8c71aae25c4304897744b57eaec70ccd3d2911"
    sha256 cellar: :any_skip_relocation, catalina:       "71eaf256d9a9108ef7b2ee147b8c71aae25c4304897744b57eaec70ccd3d2911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9874e4142f084105c7bda30819681a7af6f437ca8b1808a4f82c4d8f4f849e"
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
