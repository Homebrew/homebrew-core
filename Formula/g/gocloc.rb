class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "9375f6699a7bffad42da661b4ba7988af23dd01191da4a4b21eca8f9bb676d9a"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0536e1c6850047551d8d75a41777e563613d357efa9d9c7ca487de21cbf5d6ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e452e9000a544b1086039bd90fe518fdc8926255f7a274b0170d5c7b6d761e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e452e9000a544b1086039bd90fe518fdc8926255f7a274b0170d5c7b6d761e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e452e9000a544b1086039bd90fe518fdc8926255f7a274b0170d5c7b6d761e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "b823c57b1e74b2f39fd119e41bd39582f023dd8d8afef45267c77f361a7c24c1"
    sha256 cellar: :any_skip_relocation, ventura:       "b823c57b1e74b2f39fd119e41bd39582f023dd8d8afef45267c77f361a7c24c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04d88a1716d37d1d9c14cdcc9a3804e8e2f4959b8bb614482a2f9c71c2c2a372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1583c49ecfb4ccc1ae98e917f9c53021afbca5641bdcd70ed934064255034c71"
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
