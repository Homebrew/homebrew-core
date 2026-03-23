class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.28.tar.gz"
  sha256 "f895b690834221c42dc0d21914994f732c8f19b8c57bcb7402dc6abe6c089d4c"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12f30cd4015bf93dd35de1e910d2c7960bcc2d2e5cc9aea8c57925c5cdeffb80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "176d85f17af0c1c2571f852c616c9e5f1269a239684a725e21f62de44f913a48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b9ccd2f83872cbd39145f7a49a3f0aab3196b751b5afcf11cfd0dfeb91073c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c9ac3a9519d147099f842f517ed3b4cc210566b23baf4e416a14e822e6044c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87b39ae372e6896014c8c271dcc033215b7a5afc9fe8982da25cb60cfcb7fa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c3a288f2c38cc4e8db276d879a48f6195f7a5fc19f22b9082b55c1256e2ef2"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
