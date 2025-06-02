class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "3ff3f717618f7c47be72d6bbf82ed23c1ee529e83e51bf8a1d079717f0d45127"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fb60e9ca2ccef779bd1cb4242d4f6176b58c31d275b88905ef6171b5482827c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fb60e9ca2ccef779bd1cb4242d4f6176b58c31d275b88905ef6171b5482827c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fb60e9ca2ccef779bd1cb4242d4f6176b58c31d275b88905ef6171b5482827c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8de99d840ec8b80a3d98cebbd77a4a374730e8ed0f0d129a36ebe4f2111fd9"
    sha256 cellar: :any_skip_relocation, ventura:       "bd8de99d840ec8b80a3d98cebbd77a4a374730e8ed0f0d129a36ebe4f2111fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9243c53cb73b0e2b7830be72ceb885ba525bca820aee22c00d6db7453db9409"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
