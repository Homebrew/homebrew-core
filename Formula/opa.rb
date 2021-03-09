class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.27.0.tar.gz"
  sha256 "af792bcf9b8a82bf3a3cf3023c6ab42c5abf520835291e64e6670cb48d4961ec"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e8ae90149b6d27df8cbb93cefc37a90925ecec1327a81c46624a3b48983b371"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ea586c75fc0ab36376bd37e2eb463faf6919658153ec841d261846521ce1ea3"
    sha256 cellar: :any_skip_relocation, catalina:      "3331728290ebdee5121fb822cc00321ab771142e80231373fe5995b13f92a00c"
    sha256 cellar: :any_skip_relocation, mojave:        "7b21e5a0767aa54d733b204a88fac22dcdaca659e9d16d67721dac6526b5b84e"
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
