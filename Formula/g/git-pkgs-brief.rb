class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://github.com/git-pkgs/brief/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "8a542483ba377b9b50614773fc575ee1b5f50e231a0bce9e9984c0a1c4f7882c"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "117af7fff23c678264f4bb0444923e47b2160bb46e26895ed3b880b587668db3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "117af7fff23c678264f4bb0444923e47b2160bb46e26895ed3b880b587668db3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "117af7fff23c678264f4bb0444923e47b2160bb46e26895ed3b880b587668db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6206dca99e5a6bce2f6607852c2b5928b2a2e8874c0090773689714fcc540619"
    sha256 cellar: :any,                 x86_64_linux:      "448594b17caf41cae62d3fd00fa723bdd58288579589c941f6449cd326699b53"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end
