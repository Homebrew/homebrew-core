class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.34.2.tar.gz"
  sha256 "99799081fb227ef79255c04b8c49d299bfd57c277105092e406d7be3331c1581"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4877847e744dd7a7a4e8a071fbd45464ce87d28be21368240e317962542ca154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e5045effe47b5abca293fce624b11a802748cc175a4e3bdb182811e5ed19ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "313e9a3b2246f5f888a9060a65ab9bd11951f22cd32a36f54adf38f6dc127bc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e05bf0dd17a8f7695c07ee192b35c16f4272db0b6386f70326076079f290df0d"
    sha256 cellar: :any_skip_relocation, catalina:       "670b527a76b547ccf5b3f2c7107cdb3d30a4eba8c923d17f48f2b19ec2c06d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160fc8c3772b3028a071325781ec0ee236c2c7ca5e14706c45ee21d256c961a9"
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
