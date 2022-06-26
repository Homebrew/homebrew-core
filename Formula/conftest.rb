class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.32.1.tar.gz"
  sha256 "94e3227229c4b3ef86da85d64a877214fd627e3140bb1e28275620aa94013f7a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1206750a55396732b59725856740630d4ff142ce2ca6792e2837348059082917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2007f6a8d31f872ec922f0feec9cb86a5898687ed7e56078113f57d7df23a81"
    sha256 cellar: :any_skip_relocation, monterey:       "982f5345e3cbdee5733e68eb9ab1e5ad2eb84971dc644a7f63c8384e8895054b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6318e0e6d62ccd74c0d75006e115c54e344dc8735eb1fdf1cdd44b0e092623c"
    sha256 cellar: :any_skip_relocation, catalina:       "ea5317519d0851307bfd025189049fe86c9629ccb403aae40fd8c0bc34f90027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e184d43d5e8508b4ff52e9136930508fdc3d90472fb0ed00e279bd6e6d743c56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"conftest", "completion", "bash")
    (bash_completion/"conftest").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"conftest", "completion", "zsh")
    (zsh_completion/"_conftest").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"conftest", "completion", "fish")
    (fish_completion/"conftest.fish").write fish_output
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
