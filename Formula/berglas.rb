class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.6.0.tar.gz"
  sha256 "b6e19a80f5eabc1ab6daa55de0bd81abedf7b186b454ef6a9c32bdd459f2ad36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b613bf1ac50406c91c9bc8c8f1b322d1afe4cd2f3e4ddce1560da00f929c1092"
    sha256 cellar: :any_skip_relocation, big_sur:       "aaa3598f118b10a7dc122231860e4174cee65ff92cdedd5b0fa621146870e2cd"
    sha256 cellar: :any_skip_relocation, catalina:      "87acc0322aa1d691763b631e3138d90d9d8ff0dc10e2383eb736506cfcb21b30"
    sha256 cellar: :any_skip_relocation, mojave:        "4edd184d04304be53ddc3b45a78c7659e4367b8e7d87fc294c5218d6e341a18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae684b7cf750807d14327d34c65639a72eb1363572bc1d97fc5bf28e28dba75"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
