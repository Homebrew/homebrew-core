class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://github.com/saidutt46/domain-check/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "8ce92177fb4739b9c8d8c262c85d370173769e46411af4418d02acf70876ad54"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dc3a3825a8ed97d4801594785706fbc6de93938bc6fdc51646f90ff48ad8b9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f081fb38c78ec4e3e8e5a8c7c9c60824a57472aa3232e4c4301da3cf5eece24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58e12669d93aa4548ec57d5bba34e8debedaf5d684113e637f2fada060fd62a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7155ec86dcf2d43f982b20959c906a2aae5d6abdc1eadcf4c557a13338e8df9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247221e67740fbfaa07daeab28b729211c75fec790dbece9a52336f4d9da50d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626d05f289cc1e412d8dcd8de8328b928b1b55c0115c33917a125dd262fbc13c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "domain-check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/domain-check --version")

    output = shell_output("#{bin}/domain-check example.com")
    assert_match "example.com TAKEN", output

    output = shell_output("#{bin}/domain-check invalid_domain 2>&1", 1)
    assert_match "Error: No valid domains found to check", output
  end
end
