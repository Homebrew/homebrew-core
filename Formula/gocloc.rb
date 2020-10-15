class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.3.3.tar.gz"
  sha256 "308461beea124991c1558d8278e3a7cc0c8411c5730d444ebbd54187edeb688d"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6dc5fa859f29d07e0668c169dfc4d240dbd46a8e79fbc63c31261cdf4f6a79b" => :catalina
    sha256 "a6dc5fa859f29d07e0668c169dfc4d240dbd46a8e79fbc63c31261cdf4f6a79b" => :mojave
    sha256 "a6dc5fa859f29d07e0668c169dfc4d240dbd46a8e79fbc63c31261cdf4f6a79b" => :high_sierra
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
