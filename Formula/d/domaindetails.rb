class Domaindetails < Formula
  desc "Fast CLI tool for domain registration lookups via RDAP and WHOIS"
  homepage "https://domaindetails.com"
  url "https://github.com/simplebytes-com/domaindetails-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "a7ac0c70b6f3c10a2ca4840431a0b0c46927658a3512fcca093545dd0022dae7"
  license "MIT"
  head "https://github.com/simplebytes-com/domaindetails-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/domaindetails"
  end

  test do
    assert_match "domaindetails", shell_output("#{bin}/domaindetails --help")
    assert_match version.to_s, shell_output("#{bin}/domaindetails --version")
  end
end
