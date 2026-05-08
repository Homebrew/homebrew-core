class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.7.tar.gz"
  sha256 "4a55c8caab14d95ac8b4c89544b0e5ff9296d0de09225f455eb8dc071f182961"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ade340dd49faf60b3ef49d91d3ad33c2b065b3e0e0d70d7ea4c74be908be0357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c23a5dc60559d499fa34f97a15d9b1c7c37664cec16d0fa733a817452c7159e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd8e9ad507f34677d0db1d41cb6a00e73b341d528a3065a563e60927581e2c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e9cb4f10d1bd68d8cd2e5e75e9dc6d186d5ea717788b55f83f1639d5a7cc907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9699a8dcf88959b339e5cc91898197a5e0592885678200207f51144fc45c178b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "199fe006f4670713eb32b0e0f111f29b0eac7b8f26000d89157699f25b5955f9"
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
