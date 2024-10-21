class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "d5f875df523bb8cc884d9e118de609f0b8eca50a3c6f6c220ad01118da3387ce"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f4dc85c3ddc43c31527fd3f6df113617dd112aa22bca294e3355baa4b90d08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9f4dc85c3ddc43c31527fd3f6df113617dd112aa22bca294e3355baa4b90d08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9f4dc85c3ddc43c31527fd3f6df113617dd112aa22bca294e3355baa4b90d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf63923a441b475a1978069a8cc40370ab978ea02b793c7c63c1ede93c140ffe"
    sha256 cellar: :any_skip_relocation, ventura:       "bf63923a441b475a1978069a8cc40370ab978ea02b793c7c63c1ede93c140ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ca7a047ee079c90fa7dd1e53b51057ef72641bc296e1d3d2d043eae5ef32ce"
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
