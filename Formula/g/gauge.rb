class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "a82b647374600616f3ed2fe2e94af0c8f58c308db18a5b383550eb5ec624e4c7"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e3d0cd531e57dbf999a50a98ff02573cb3ac46e455d600da638561e8ba8d309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "719231b264a7ae20478fb00aab9a7683022f1a1da392e943ff3dfeeceb5dcba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "305660be69bc80075bed4110209448043069214a15db2620e9cdb2a77c494f3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "275b675b4ce5a92b8b8c60cb1b408564602baa301468f0bae7adbc9b77d2d064"
    sha256 cellar: :any_skip_relocation, ventura:        "9d547e467740f9a6e2ad6f2f09b8a9659a44ad348f28dadcec11dcbc2a9b5fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "c5f1b3ab3ee1b3466f2683d70d8db2ca492964e033785557156a2d9e4b0fd6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7027a3b5ceb045f84e42bfcc43fe4489229a3b64753f25c9cce2771bd62dd6"
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
