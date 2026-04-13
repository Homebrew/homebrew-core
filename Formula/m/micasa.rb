class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "68d92e9ca8c6bde3eefac0848eb0e57f33fe8d6a2a8529aed9eed8192df9c867"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f60bcc2de85bdeb81666017c2a95ef835d1725665f45044391d2033ecbef0646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f60bcc2de85bdeb81666017c2a95ef835d1725665f45044391d2033ecbef0646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60bcc2de85bdeb81666017c2a95ef835d1725665f45044391d2033ecbef0646"
    sha256 cellar: :any_skip_relocation, sonoma:        "94c84f13c602b51078a7ef814c78204345eafb606608cd41c15e8a748ce2608b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "795e70eee01432c4d4d400373e572bbe1fa7f92e8608c5c08bb60feb3c226253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c2843a28f39f04ee7ca46ae57831e598b0a7ca5fed161aedd09fbae4f7a286f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    system bin/"micasa", "demo", "--seed-only", testpath/"demo.db"
    assert_path_exists testpath/"demo.db"
  end
end
