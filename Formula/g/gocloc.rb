class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f75b9b086488c03422af273fbf98507417850895ed40ffaa0e745c627c7b2f3a"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e61208963fc60ab3653ad04d87dc8632c4b7561451277670109b8ece15371be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e61208963fc60ab3653ad04d87dc8632c4b7561451277670109b8ece15371be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e61208963fc60ab3653ad04d87dc8632c4b7561451277670109b8ece15371be"
    sha256 cellar: :any_skip_relocation, sonoma:        "9db335d92dd572edfb9cfa35d295670c6933d76e8075af3a17b3ad062a0f090b"
    sha256 cellar: :any_skip_relocation, ventura:       "9db335d92dd572edfb9cfa35d295670c6933d76e8075af3a17b3ad062a0f090b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81cea40130aee4a6572e5477ffcfc374c528d1586066770d6c5337b29d1bd616"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gocloc"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    C

    assert_equal "{\"languages\":[{\"name\":\"C\",\"files\":1,\"code\":4,\"comment\":0," \
                 "\"blank\":0}],\"total\":{\"files\":1,\"code\":4,\"comment\":0,\"blank\":0}}",
                 shell_output("#{bin}/gocloc --output-type=json .")
  end
end
