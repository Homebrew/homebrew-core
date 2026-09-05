class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://github.com/git-pkgs/proxy/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "6c11a75241d3cfe4c761d9b25dc691862206284173d23d7aa6d29c988f80ff0d"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4aaa889f6efe5d370a352ecf133c9e792967a68297814fd6c1de84a4406c4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b486d5235c786c4da3a0dd71a561d24e9010c0669bcb7458929b3f8b5a307fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57810e998e2d11cc505643fd25e98fb7b76c8a49cda2fc21188e7b7f32d44fbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc15257fbe8485700261012c843b297e677659e42943c2e24a9cccf7d7e90a3b"
    sha256 cellar: :any,                 x86_64_linux:  "b2ea13b6f85c9ec8819ed78f9e8af06a5fff6bc2487d7f8d06d6e8fb5ae54779"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"proxy"), "./cmd/proxy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxy -version")

    output = shell_output("#{bin}/proxy stats 2>&1", 1)
    assert_match "database not found: ./cache/proxy.db", output
  end
end
