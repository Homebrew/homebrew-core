class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.39.1.tar.gz"
  sha256 "c2ca1f79da342e5d9b1f525f78617c7b44cb24cced00ddd0763a659a9d39031d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "147c99c35b61f35abff85b716301b985940a7e3b208cf3f01989e8d8d9d56d96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fb9c04fb9204a42cf219f472b80878408d2cd871386436aba36e1a375b5adf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b6c584d8e64ade9fe5e14ff5be0faa2c0dadd68cce1f2c7c4ff85d7ed991a8e"
    sha256 cellar: :any_skip_relocation, ventura:        "32b5a642ad90568dfbbd08a0c0751896b2cef13fdda1f13a0035eee87e3d03a8"
    sha256 cellar: :any_skip_relocation, monterey:       "cf6c9d81386ec36be7bce79e2ab008fe32fdba2b3ea3a9ebdf99686b94ff5d8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa1eddd54dcfc4407b96e8733a970622988dd901441d293dcc0e7cdbf1407211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3786420b60f3ddc9a59925b7a0358c0a493eb0908aa249aef59fe278495ab1d"
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
