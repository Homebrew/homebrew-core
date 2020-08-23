class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.23.1.tar.gz"
  sha256 "db84bcf9040623a5f7977e7b4d2fa7f15ac61efdbd2e6c13cafe1bf67bdac07a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94d386069d2232a2725076c34224e9e99506b6f258975d0dea54473ed78c8e91" => :catalina
    sha256 "2eccfc6cbc5d5afdcecf3b03a2fad2acc301c81577f7484a2817e01816013c54" => :mojave
    sha256 "3b63692aa52d8cd54fd33289fc684c5de26e03b5534738c81e91c002f8a35010" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
