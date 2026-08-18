class Ldapx < Formula
  desc "Flexible LDAP proxy for inspecting and transforming LDAP traffic"
  homepage "https://github.com/Macmod/ldapx"
  url "https://github.com/Macmod/ldapx/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "fec47b73d34ac050c7107fa04614116d68895d9e63b6ecd371da224b7cac3ae0"
  license "MIT"
  head "https://github.com/Macmod/ldapx.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Macmod/ldapx/internal/app.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldapx --version")
  end
end
