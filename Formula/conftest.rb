class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.24.0.tar.gz"
  sha256 "adbb6016c0e17466ee3532a36e71ecc3497e2b054cea159c12fd8cc1ac7af2a9"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "13b15a48a40b4e2abc93bcc71bee8f544c15c5f76ee7cdfef90dd9da771aa3c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "259a6e4fffe0e3af142d1a98a6090b206828e8cef5fb0b809d05a4129ffb1516"
    sha256 cellar: :any_skip_relocation, catalina:      "e7a72ec05406e510ed89b963ac0f5072b744fb5bec2d6d172f6ec8de00d3c6fc"
    sha256 cellar: :any_skip_relocation, mojave:        "04ced2986480ad994f1c34254f8f946e6c33ddf19432a3bcc3077cb31af31d1d"
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
