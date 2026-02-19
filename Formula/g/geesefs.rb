class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.3.tar.gz"
  sha256 "d9265e6a9dd82faa7fbe0cb85e1a6b572948d855a3457bb0bb9dc0df60bb7e70"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2a7584fd8788285e1eafc28ca132bc1c7caf1e6eb4829d3cbd8ab0d8a87cf1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48aa198340fc9e44af8c1bb764b1acb39c40898da84bb891a2ff2c6682d3ef72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8f20a8b251c9cc1139506242928431f8f0236596a1e3d83f672cda218783e39"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c88310b0460d07fda844eeb4cfb21d488132097f406c4e95945759f40b3721f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4172b2ef62b0e386b3bda74772f3c6881c40c8053b306f70d99a0bc73b09b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b8dcb30edccbea5d8edc6ef5395bdc8e7460e97c36d4712977fa758c2054b4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    output = shell_output("#{bin}/geesefs test test 2>&1", 1)
    assert_match "FATAL Mounting file system: Unable to access 'test'", output
  end
end
