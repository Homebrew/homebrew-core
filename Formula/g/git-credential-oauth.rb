class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "ee894f81c63dbfc9ff7fc59affce3cedca85e9ef3d7b10ea6f0af86e712418d7"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ff39420fedd201fd8aadd2d2e970820c60e6daaa45eb2498c4d21a51d4beb23c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c684c917e7d4382144bc870ae80ee49998b385e788a756ec3bbfa01b7537820f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f9738ad51f4efc8f26875f5eeddf24f1c42c098e42d300665d37c46adf2377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d26d5207332197586ba00d0225725cceea144e4371657e5fd724b5df2358487"
    sha256 cellar: :any_skip_relocation, sonoma:         "35fdb037a9fbb443ccdbcbd31da1b8a1a86949b9a060855cfd2c7971bc586e1e"
    sha256 cellar: :any_skip_relocation, ventura:        "7736b8dec4d2ae0251bc131ce81ee889b266a8d09519bab77d8976f7a062c9b5"
    sha256 cellar: :any_skip_relocation, monterey:       "69ecc891b5e930f0ec0b2c37bdbccd02232ae2b58b21f6a8f35420e109ebe9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b07ccb69689e7fa321e3e0567612dd2423f83a2b33af12a32ccf0976e0b18dc0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "git-credential-oauth #{version}", shell_output("#{bin}/git-credential-oauth -verbose 2>&1", 2)
  end
end
