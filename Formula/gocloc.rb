class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.4.7.tar.gz"
  sha256 "dec2cd7aafa544f7e889a180fef975e874dd717cce6d4923a0408745b4ea12c8"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9170c7507ab4711ef20c771dbf9a8512ad29bfd67c622773026fd7ac92be36d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9170c7507ab4711ef20c771dbf9a8512ad29bfd67c622773026fd7ac92be36d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9170c7507ab4711ef20c771dbf9a8512ad29bfd67c622773026fd7ac92be36d"
    sha256 cellar: :any_skip_relocation, ventura:        "b872daf62c8feb4bd208f5879b0aeee08ae84f6c3e649d3ed7e3595757a425d6"
    sha256 cellar: :any_skip_relocation, monterey:       "b872daf62c8feb4bd208f5879b0aeee08ae84f6c3e649d3ed7e3595757a425d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b872daf62c8feb4bd208f5879b0aeee08ae84f6c3e649d3ed7e3595757a425d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f83d8e9c90d1ab28a41206ab628ecd5da73aa27e08cabbbdf0d0faf77ff912"
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
