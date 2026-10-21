class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.7.0.tar.gz"
  sha256 "de6f4f943203e394c586866941ca693975ff922438cf4051f0e2cbd87679b9c3"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16aba0c08fd17dcacb11df047bdb6dd4febe1632ae354c3c765b00d1191d7cd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16aba0c08fd17dcacb11df047bdb6dd4febe1632ae354c3c765b00d1191d7cd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16aba0c08fd17dcacb11df047bdb6dd4febe1632ae354c3c765b00d1191d7cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e13f87f7901b3db72d14ffad03f8376009ffefc09fbc824640a75d758e5b8898"
    sha256 cellar: :any,                 x86_64_linux:      "929e77d4cc48807e6480de9554bda2830aa86b4cd7910f10ab4d39be492b7c30"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end
