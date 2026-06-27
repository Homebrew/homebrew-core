class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.0.tar.gz"
  sha256 "034e9645b980071dba922839e0878680ff1130fa3439115cfd525554e01a2340"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b0af6dd0e69945d3f956b4cf086725a4fd84ac6f1c4bfdbfaf50cf81d402cea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b0af6dd0e69945d3f956b4cf086725a4fd84ac6f1c4bfdbfaf50cf81d402cea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b0af6dd0e69945d3f956b4cf086725a4fd84ac6f1c4bfdbfaf50cf81d402cea"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d33446f9ac655dacfce1022c060c40f80a8b1fa5a5bfd82b0d4d9abf2b08cb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd840750dd64791e3dba466183668413dbff8786abce47b5e367cd61affdbcdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "130113487c2a78d51b2a8a2bd4a923b8e55a4ddce1271b091573fcff88e6ab3b"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
