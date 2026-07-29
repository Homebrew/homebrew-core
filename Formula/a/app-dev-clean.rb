class AppDevClean < Formula
  desc "Dev-cache cleaner for React Native, Expo, Flutter, Android, and iOS projects"
  homepage "https://github.com/latif-essam/app-dev-clean"
  url "https://github.com/latif-essam/app-dev-clean/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d50a6103b61aff56d05f21cf65ca189afff0c521715e62058d94f324fecab984"
  license "MIT"
  head "https://github.com/latif-essam/app-dev-clean.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/app-dev-clean --version")

    output = shell_output("#{bin}/app-dev-clean js 2>&1", 1)
    assert_match "refusing local cleanup", output
  end
end
