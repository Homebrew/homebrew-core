class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "2fe03975acd6eb184c3cc6e0bb5d49f973c39aa518d36279685f442c23e87956"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb2caea11dbc2ea5574126e34ef8c4519bdf0f89e9f3e70b08fd616299c74d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9d6173e33f7d076b8bc3c4f49fb876fa9bcfe5d9bde2cd9c2b1c182174d968d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "286bc78f6b3ae9db1b6b4695ba9e430d9b465a2130bb6248335fac1eede0f42a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9954dd39e7bac548e40b4df57f5d2f16afb2e41e6b148143eea81fda9f40f467"
    sha256 cellar: :any,                 arm64_linux:   "e2024617f5c29f465aa2b2809dabbf7f7ada2bf608a3640e07435c0c38fc91a1"
    sha256 cellar: :any,                 x86_64_linux:  "e1e4cbede7a49a7256be6dd329a654a7d94e50604cd82601a642e33b0bb6b043"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
