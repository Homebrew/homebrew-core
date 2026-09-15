class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.3.2.tar.gz"
  sha256 "9ac65a1a417c6fe8533ddf2ddb197d78c608179f258de02c5fa53152ce6ff027"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd989005961584a2a50ece391237de040aec13d5ebb93d8ebac9628785a2c6c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d49db05f7c7558fdb825f6c02b5b12cdd3b19f7bd444dbea55cf2ac2c8d905ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60d3b2c500ade2dc190e9884fe64841e3e7db5a57f199ebe7b5565a15c340e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "65682b8410b7d855dbaebfc1b03de05eb95df800c362cda4e2e24f0cb8a48b1f"
    sha256 cellar: :any,                 x86_64_linux:      "579f3fa833280cf0e5515121c1d15edac9d60da681a761f32cdc1c5f43f5193a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
