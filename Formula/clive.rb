class Clive < Formula
  desc "⚡ Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "eb4c32ae67cfb8c8b76733fec34047718cdf2d2682125480d478b5a313b04a32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "905bab7ac96d636a6d46c458a42bf4348c2c8c2d2334c6c50c6aa560deeec9e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "905bab7ac96d636a6d46c458a42bf4348c2c8c2d2334c6c50c6aa560deeec9e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "905bab7ac96d636a6d46c458a42bf4348c2c8c2d2334c6c50c6aa560deeec9e0"
    sha256 cellar: :any_skip_relocation, ventura:        "5f79bdc37333481124bdaf626c37a8d91907f3ea8249f7130292ad8fcbb695b4"
    sha256 cellar: :any_skip_relocation, monterey:       "5f79bdc37333481124bdaf626c37a8d91907f3ea8249f7130292ad8fcbb695b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f79bdc37333481124bdaf626c37a8d91907f3ea8249f7130292ad8fcbb695b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7502d6977cb4822020ba8d40de5a9b3959817f4c8ce16be436f21a5205f7bb71"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_predicate testpath/"clive.yml", :exist?

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
