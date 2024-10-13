class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "b0beaebac62e043758da19df369df3d06832e3466cfc649110b4992260a56ceb"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dffd7158f1db321d5fd4c9ccaffd4f3141f031d8791b370fc323419c27a583a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dffd7158f1db321d5fd4c9ccaffd4f3141f031d8791b370fc323419c27a583a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dffd7158f1db321d5fd4c9ccaffd4f3141f031d8791b370fc323419c27a583a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dffd7158f1db321d5fd4c9ccaffd4f3141f031d8791b370fc323419c27a583a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b73fed25edaea71c7426cc9a53e427364fb2519d80c343659275be7f62a76209"
    sha256 cellar: :any_skip_relocation, ventura:        "b73fed25edaea71c7426cc9a53e427364fb2519d80c343659275be7f62a76209"
    sha256 cellar: :any_skip_relocation, monterey:       "b73fed25edaea71c7426cc9a53e427364fb2519d80c343659275be7f62a76209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01726ce814902b702551f79248cdff0d9bc393b19ec4c2de88a4866af0aa552a"
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
