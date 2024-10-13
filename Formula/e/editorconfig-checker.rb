class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "b3d927bbbf3a89bc75d91ce00dcb3c836906e6522097c836285adb26850ca3eb"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "647b956fd0c03b795a17b81bd6572efc1c8079a6e91504edeb75ba0bdbe55ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "448f1ebb1897e6d07f5d6928066339ce01ea89f7e1f6e820bbbd483dafac853f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "448f1ebb1897e6d07f5d6928066339ce01ea89f7e1f6e820bbbd483dafac853f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "448f1ebb1897e6d07f5d6928066339ce01ea89f7e1f6e820bbbd483dafac853f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e16b0702aa4bbba6586ca67b2ec147fd781c3b480f1df50a68eda6d4eaa090e1"
    sha256 cellar: :any_skip_relocation, ventura:        "e16b0702aa4bbba6586ca67b2ec147fd781c3b480f1df50a68eda6d4eaa090e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e16b0702aa4bbba6586ca67b2ec147fd781c3b480f1df50a68eda6d4eaa090e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc53564fea2c9f3fddc605ad05d7e083be27a830ade4236713e8699daeb71be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
