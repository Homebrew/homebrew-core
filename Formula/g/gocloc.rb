class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "1a1295e5814acfda39a3050cc5543084efff399b19a5d42d699a9fe59a18c1f1"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    manifest_sha256 "4ca8884c71345f556e04782bad3fce487e1f7b135e36902a11f336ab530a1eea"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cfbb41e354f38ed3a6a184ce6f2c3770b21c185b15a64f2b27b6ab8684edbe5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cfbb41e354f38ed3a6a184ce6f2c3770b21c185b15a64f2b27b6ab8684edbe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cfbb41e354f38ed3a6a184ce6f2c3770b21c185b15a64f2b27b6ab8684edbe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea43befbffa1323c3d8ae582b2d115469ec3eef525c9b4b37293eff953ca306b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "352bcb225db213cf821e464e05e507297e219d7a500868e2bdef5d8e91019634"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gocloc"
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
