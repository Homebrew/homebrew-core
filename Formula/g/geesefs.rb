class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.6.tar.gz"
  sha256 "2cc6d10040f6611015a162038c46b14174372100476bd4d20bfa7fa11fa32ff2"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eaa0edd3adfa049ebe97db88a2fe93435a1102a88d5b96684b40ebe3e9ee7a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "768fb9c33cf83f892165427d529743a5a1c246e47753027af8aec8c566b4077f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82adbd5202e9dbf0c69473ecf353583f5c1d43058577c2986b1bb82b0ca22b17"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef30eca714701c842afcdd303eb268f3bbc42c8608d5158903adc9efb7ac4886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c75a56e1115a228f1180b39038f7ffdcc2cb4765781426042103a3e96f973eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3702b027c9c511c9dba24229f7bc773e4e12f6c8e38190c7f8f4a0ba75798b8e"
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
