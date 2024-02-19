class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.8.0.tar.gz"
  sha256 "639ed029204ba548854ff64f432f01f732fccb161a29c7477b70911576840ac4"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b50965fa2e05ee16d5a05a6adf893a00d7138af4467962769f5dfaf09ffad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53b50965fa2e05ee16d5a05a6adf893a00d7138af4467962769f5dfaf09ffad0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b50965fa2e05ee16d5a05a6adf893a00d7138af4467962769f5dfaf09ffad0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f451b76a60b9180dbad41e6155023251fdf347fd53650f7400282babbf4dc81f"
    sha256 cellar: :any_skip_relocation, ventura:        "f451b76a60b9180dbad41e6155023251fdf347fd53650f7400282babbf4dc81f"
    sha256 cellar: :any_skip_relocation, monterey:       "f451b76a60b9180dbad41e6155023251fdf347fd53650f7400282babbf4dc81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e48015bb1be45cd723513f9931c29730f259b8874dec02f81f465bd6cff3be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
