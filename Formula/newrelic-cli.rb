class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.60.1.tar.gz"
  sha256 "4285a245748aaa850240ddeb9980359e883756c9f8faa95a90cd3690e482451d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46692fedc52df6df452d5119c31c0b369a09c6d4d2815c7be11669a0266d808d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28b2ef993e32c00e2d2055b14efd4151ad7a7ae12739a678ea3352b2633f40a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f75be8a0276ca7ccd9950fe8eea9ad0c56335c3a6123393f7ae4323c2fb397b"
    sha256 cellar: :any_skip_relocation, monterey:       "a366772feb2b1a4f16f57b00ec6263f32575c62311991d631ef796834ad5b8b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f03de6bf6fd279af4c458057e45c2ca92cea37cada622ebbf1216659c693627"
    sha256 cellar: :any_skip_relocation, catalina:       "a46506589a3afab3c4b1c4320ce47b8fe25da662c120366e8e9f68614766b237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5681da102c48d476c55ad962b565ed73eae87d8219ead54ec91a29b2ff4a85f"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
