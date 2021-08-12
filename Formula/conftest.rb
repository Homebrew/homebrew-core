class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.27.0.tar.gz"
  sha256 "b1a38065a1de5208ed72250b257149e21e3381423e6e3028adb214fd4380f3ef"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "854edb50cb872782f0aba919f067158ae5a36c068c2ae55b70afd65cf7376988"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7b3aa341bebd7501b6803177eceff8bf6dcfff38e156e3b8efee4a2723b414d"
    sha256 cellar: :any_skip_relocation, catalina:      "03cb3c6779a1b379d600dea744895e9d497118db9ed766a342ed0de39953f222"
    sha256 cellar: :any_skip_relocation, mojave:        "734478ed8f1dbca7fe4f2e2334b1c28625819fc747899dcf17def4fbe5278494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0afd80a585ba50db81b22f8d9c42c1cde14e560a0ae640ee7a483f45e066a9e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
