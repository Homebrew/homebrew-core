class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.10.7.tar.gz"
  sha256 "5ca0c9b0220f9b30f42ffeddeee9fdf5e63feda55d3ed9d3f6dfdfd30da15f6d"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629dbba49bf9b7ba239e1d7e723203959d3b574dfc7604ac557d9ffd8a1f98c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629dbba49bf9b7ba239e1d7e723203959d3b574dfc7604ac557d9ffd8a1f98c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629dbba49bf9b7ba239e1d7e723203959d3b574dfc7604ac557d9ffd8a1f98c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbb3f3992ac2a0313db8b747053f8cfd831188c4c808edadfa4db44acfb685b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10e278e9ae9e08d8c3200b18fc2b3635d3ac958019d16c67086c2bd155b5679d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3b6c99b1bfd2b8264b8d297fd0dc689760d886f63a796055f66ff873f9f809"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
