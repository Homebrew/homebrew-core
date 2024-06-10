class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "64d9adf13daf1748865a0f6cc18506c9adf30b81e6cbc9408116fc79494f6c64"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12b25e100b4a8a554dcf8aac195a35d08530c6c92aac8f484427a818eb281632"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d179741accabef4d4f3d860c013ea591fe80a9ab2c9648469518b06e576fc01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0af4978c0a6364f86e771f37ccfe92dc2ce10ad4b53339c1f9d448163639bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b9f8fad25aeb3dcef89583c35300fec6caed6fc631e643ad265114e427a947a"
    sha256 cellar: :any_skip_relocation, ventura:        "9a31cd1a1c4c2560d3f9553260fd8d838d47715277105fe02fa17ed7d9778f73"
    sha256 cellar: :any_skip_relocation, monterey:       "c34b2730418865b7e76fa9cfedca86f5f57dc4fdd7d48db87b2d3dc73b3fc208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef8aa837e8d9f4e86482a663ddae9057e08dd540e5f08fed76deab4503b11ac4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
