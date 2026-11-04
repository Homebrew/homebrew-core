class Godu < Formula
  desc "Simple golang utility helping to discover large files/folders"
  homepage "https://github.com/viktomas/godu"
  url "https://github.com/viktomas/godu/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "09869710652969b8a9d227dea4ac33893b1f538197b101affa6a8a9aa6a50474"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4797ae57c05cc0f50ffb1b613ec216197f3f4669fd0fd37e6c1136a64c8aaed0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4797ae57c05cc0f50ffb1b613ec216197f3f4669fd0fd37e6c1136a64c8aaed0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4797ae57c05cc0f50ffb1b613ec216197f3f4669fd0fd37e6c1136a64c8aaed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b08a3477ee8779315331649419c3f31668cc2665051addf5c75720a2204197c6"
    sha256 cellar: :any,                 x86_64_linux:      "eac901e3a735f9150f1a4f0ca13157992868aacce350e21094b5be3851ddf989"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # TODO: replace ldflags: value with :goreleaser once fix PR is merged
    # https://github.com/viktomas/godu/pull/106
    system "go", "build", *std_go_args(ldflags: "-X main.goduVersion=#{version}")
  end

  test do
    # godu is an interactive TUI app
    assert_equal "#{name} #{version}\n", shell_output("#{bin}/godu -v")
  end
end
