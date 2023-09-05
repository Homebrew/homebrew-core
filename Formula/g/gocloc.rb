class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.5.1.tar.gz"
  sha256 "ca79858ebcc6b463992ec8b86d927d1713a0bb6f4f8546a4f7750a156829dcd9"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc663abeb85582ffd4fa48e2ff7b398b9087d1351f83f549ac72d67b5db12945"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc663abeb85582ffd4fa48e2ff7b398b9087d1351f83f549ac72d67b5db12945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc663abeb85582ffd4fa48e2ff7b398b9087d1351f83f549ac72d67b5db12945"
    sha256 cellar: :any_skip_relocation, ventura:        "21fa97d6b4b718d29bd17495203d9d18852958dd566047c789e9c3687bf0db69"
    sha256 cellar: :any_skip_relocation, monterey:       "21fa97d6b4b718d29bd17495203d9d18852958dd566047c789e9c3687bf0db69"
    sha256 cellar: :any_skip_relocation, big_sur:        "21fa97d6b4b718d29bd17495203d9d18852958dd566047c789e9c3687bf0db69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "356afb4d5253c8c03cfec3e645a4b0b587a6a76e9f5d9b69c4ab7f3abfdf32ec"
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
