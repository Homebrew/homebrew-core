class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.9.tar.gz"
  sha256 "beee3771a2bbe652c49f9e8048b4f3e1ef2f606432d496e8de574c9355cb2dee"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09f67dd31ffa1ea952cd08bafd3bd0c7986d207b32308b4accf8d2910c3bcc23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445329938ca4cb40e01cf61cc8ba9f0f1d3d6e15a548575d6e8edb358b8f0554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e5f7ba6258e767062ec7b758ae8e27c7b20b86e59b42ab77e99ede15fb1cec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34806013234398e8e8f7d71bab559e60972f57e68f15d8d63aca071a204b423a"
    sha256 cellar: :any,                 x86_64_linux:  "b66ab0518c8bcc6ecc1e1c9b43e83824d8fb9ac8eaccdb886cf0cffc622124fd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    output = shell_output("#{bin}/geesefs test test 2>&1", 1)
    assert_match "FATAL Mounting file system: Unable to access 'test'", output
  end
end
