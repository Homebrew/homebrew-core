class Amass < Formula
  desc "In-depth attack surface mapping and asset discovery"
  homepage "https://owasp.org/www-project-amass/"
  url "https://github.com/owasp-amass/amass/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "cc6b88593972e7078b73f07a0cef2cd0cd3702694cbc1f727829340a3d33425c"
  license "Apache-2.0"
  head "https://github.com/owasp-amass/amass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "db5368b64cf5b63604ae151e8a4e0c115c3901ae1ca3d9adf859da46dcbb494c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f50a72e211dbd6ad730f2b288656f74ae46e25c07448c3c37dceceb2b45edc4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d71b584ce13afc60ad62a25a9f2df1fecaa43b30ecd914557374e61c146b4ece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84dbad75673b4a7fe5b50eacb186f995cced136874ca05a9a9d2d32788991276"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7ac1d640f491125d3c20fb4d9478a98c5e832fb84d483ebebf3bcd4dcb79e28"
    sha256 cellar: :any_skip_relocation, ventura:        "3a9b971b823bec3ebd1408d1ac16cd33bd3a6a3fc711a13be734ac6c54e08c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9b09adf0a93790379a6ef01864d633153a8d57601817ef26d6a7f1fbb58abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea781b89ff2a7b5bb0035161e5e80466a65d9d1801169452fa7abf5ce35a1f46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/amass"
  end

  test do
    assert_match "github.com", shell_output("#{bin}/amass intel -asn 36459 -include Google")
    assert_match version.to_s, shell_output("#{bin}/amass --version 2>&1")
  end
end
