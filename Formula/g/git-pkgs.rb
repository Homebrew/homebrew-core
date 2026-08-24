class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "d0c6fff49fc7377f87782c9c47fd84336912181f3594fcbb41cf1eb53e92bca9"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb3f24d045a049c13098e3a6501093639a2a71772e5ef733e8cb2b7f223c82f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb3f24d045a049c13098e3a6501093639a2a71772e5ef733e8cb2b7f223c82f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3f24d045a049c13098e3a6501093639a2a71772e5ef733e8cb2b7f223c82f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0404fb00e72507ed7865607f72ff85c33b5026b1395bb59494ef214dbef7d8a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83efa3bfa258c184fd41d5ff14e317931052c905f20e802c58deca2aaed5d234"
    sha256 cellar: :any,                 x86_64_linux:  "8654cc8fed9ddc37b1b3528fc48afbd0dec6efb7bd115f9565a5f962c30e65de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/git-pkgs/cmd.version=#{version}
      -X github.com/git-pkgs/git-pkgs/cmd.commit=HEAD
      -X github.com/git-pkgs/git-pkgs/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    system "go", "run", "scripts/generate-man/main.go"
    man1.install Dir["man/*.1"]

    generate_completions_from_executable(bin/"git-pkgs", "completion")
  end

  test do
    system "git", "init"
    File.write("package.json", '{"dependencies":{"lodash":"^4.17.21"}}')
    system bin/"git-pkgs", "diff-file", "package.json", "package.json"
    assert_match version.to_s, shell_output("#{bin/"git-pkgs"} --version")
  end
end
