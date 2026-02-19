class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.25.tar.gz"
  sha256 "bcc3d5370de5f73d4a692e4b36b0d5fa88c5c0329e507e3466248ea482bd14ef"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8453ede03937101c2d62168e32c48b59a7469124c431f3a25fe03a48719eaa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1fa33af7370f76bc76c3bc50e8123b9606d727531774d436446c525b949393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0230e1d86772d5c268c676674264358d5360985f175fc81f416459910dd8403"
    sha256 cellar: :any_skip_relocation, sonoma:        "71dd71117b690bcaf7d475f8ad0517c90c3f63d14fb1b8ace6174d82db5c9eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3b6d6f875283dbc52adecb4d7eae156e5c6415898fd32386b20b5f0eb97d262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d19a8362f98f563cb8db03ee361696f8fde12f565ec8267bbe317c1d3930c7"
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
