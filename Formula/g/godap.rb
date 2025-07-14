class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "94e7e973362c60539aca38399467c0e3f1e004063e846f83a0bd3d3616303f0c"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1f21d3e7fad07512b9f5697c251311a00dde15fe365d179017a81d698914d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f21d3e7fad07512b9f5697c251311a00dde15fe365d179017a81d698914d3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1f21d3e7fad07512b9f5697c251311a00dde15fe365d179017a81d698914d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b7e35888e9d5f1e5586f8d6c1101dec44a28bbfd4f1964674c443997bbf0dea"
    sha256 cellar: :any_skip_relocation, ventura:       "0b7e35888e9d5f1e5586f8d6c1101dec44a28bbfd4f1964674c443997bbf0dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3806997b15103355d597475de81055385692105ded8bcc4dd4a424dedfbc905"
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
