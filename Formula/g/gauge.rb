class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "75eafd7b6105ba0fcfc38789268c994b926bbfe77cf9f16c4b1d7b846f59ec8a"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31db3867292dbde96a63a5edc750e7a2a110932bb3d9a32c597d2b8169b4872a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba25ce084b12e001dda367fed9278e287dc32d854c6399f948133ee454d2e371"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "289394323eeb8d959bf671d4955769345769ba7b09c4357b3e61ada0ac6b5a56"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a5596ed00f78ba85988954c505ad56225d3e38940aaaae66684cad75bb5145f"
    sha256 cellar: :any_skip_relocation, ventura:        "f7c6c812b6feddc4f7a545777672db70b45970a619e267f0ae1aecece1cbdc40"
    sha256 cellar: :any_skip_relocation, monterey:       "9e702adec46cffb58d0000255db1bf902f1eb07f07fe1b67c81f5a4d9b207249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f4f3fc62b247ab4262a3b50770e1242889b2251177a1f997bbf60400fdff1a"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
