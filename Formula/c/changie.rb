class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "5eaef2de621e1502f0c449cc52b48d4de4a7373353f5008d0334172dc356b336"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a3dd0fa6f731cfd6ca663d5b270588d8e3a10d60905ca27118a3e967328b918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a3dd0fa6f731cfd6ca663d5b270588d8e3a10d60905ca27118a3e967328b918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a3dd0fa6f731cfd6ca663d5b270588d8e3a10d60905ca27118a3e967328b918"
    sha256 cellar: :any_skip_relocation, sonoma:        "710977deafc0911eb9915c0c3cb443285eef91613418c8a89423ea66629f7c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2c03d3d8341d8692f750079a3aa62ec41f3c2000b5d86f4a90c77e486a7b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727bdbc4da8c14f3fe87f6aca29b581d6fa8af493e4fb95b283375050ab938f5"
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
