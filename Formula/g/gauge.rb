class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.16.tar.gz"
  sha256 "baf9e73b0d4b2efc69a4f3b18f31974629a90be6cb9e54ce90935b2c7700528e"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76a313f5142e43f247541a3bf3ec21dc9a5b3906a4236684e2101e92526ae74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b40576e0b4844b4ecc998ab0f42d84225e4c379730e49a136e5fb24a4df9f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9836bd190756b64451629102234b5ba269f48489964f58a05aac1af59260d642"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a44bb09fa06166b64a12a09245dde9c42573322b9cefa5d5af6f4aedcd4e13"
    sha256 cellar: :any_skip_relocation, ventura:       "940a33d1868bf43fe4090f178663e02406b8f7b931ee25e8709fa21de8b35036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1440076c82cd4f63bc245d3f84a2c36ba0050a9088def9e5713b0e82dcaf4d89"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
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
