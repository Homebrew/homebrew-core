class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "5f8470d1ebcf2a17f71927a7e43157734f9e3f7b91592d5b031b4615a00d5ee9"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59ce9a0541aa31a9149f31e7d5b2539ccdd92f96b7a8df62ed6f1266456c431b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62cb664b63f02c43a34653701053832caad9293b8e002751aba5e200ec3a1c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a01453dd3cb89ffd47dd37be3e6002043ff9b1532ea1192be769bb739e7e30b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd7df3c2b76abaabc4987747e5560fdb6bc743a1be56d78d4997169e18de696e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f504991e1ce345c3c9c5579a1f0a2eea9d6b2745c3ce57ebcfd578b95da4510"
    sha256 cellar: :any,                 x86_64_linux:  "c8e50b6e6563a1408d903ec4e334a160063374d790b621d25563177277904c48"
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
