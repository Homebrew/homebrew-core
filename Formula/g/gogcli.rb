class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c1dcc14c9f72500a1f2a40b58dbedbbbb008e85c7719e76e9c39f6ed7577faee"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cb9bb259a2b2f0ce08f9deb926ed40150f6ef2e93d2a38968ca54295a44a59a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a393c0e4aba1decaa4f70b8c921da7844ac2dfae80837b1b97e669161b4d058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e2234b94962337694a645173a4c7c5fe85e251fe8c3a74fac7e66e4e8ad274"
    sha256 cellar: :any_skip_relocation, sonoma:        "8590fb2fe2aa79c0d0433e920c2b033092b8dcdb4e3bfc0406f02a3d7a021915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9705e662f2867b2507c70becebdefc6e56c1679f86977e3b0598037e1c864580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6df2000e7237745c50feea2e61cd7e39b4dc579fb93864987fc84fe5dbbcd8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end
