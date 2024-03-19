class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.19.2.tar.gz"
  sha256 "a3ddcb2f128470cbd6b1dc1bfea119c69ffceb9deaee40a5a5229db94938a68f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88155f85d7b0d2d33b003c3f5a382d1151c94c4d835e4457fe15230b4fdf956a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87bc5dde74f3261a8ba26c98ba3c18cab3a6230cde12a482c5df7cb3fb14dcbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4775f63284414beaaae088b91dfa0f7557f7165f9c09b77cac0a6ae90897b986"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cd75184cc0600c44493bf848710fc2dc2e782fed1316194344fbaa902dadc83"
    sha256 cellar: :any_skip_relocation, ventura:        "fcb133055af52ddd7c3447973ef917f2c75489d12222317c4629667e2b82db3d"
    sha256 cellar: :any_skip_relocation, monterey:       "42acf29a83737dc3b5c35a3725a17242bb97251dff9402cea396c75a122c5c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b445a643d9136a98ace5c346bc3236a574afef31cc232ddd1fa32890aeebf6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
