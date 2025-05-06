class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "ec4331ab6756f255cfb1d2042696b35bd51600659e43982fef9929f9a96fa503"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba05a818105f466ada749d50ec3b67e96c5f264da583b0c3037be7c3e5164398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8132964d1346f869ce1be475c036be83ed5efac76a52b5c7d6063f6454d430fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9603ef94b6300ce8c489c5964547a84c4941dfde8d78b19edd8ed490c4ff3b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e6050d1ed6375e12a34110b065e62628fae19ab7015c7a6a52ba8246ca791f"
    sha256 cellar: :any_skip_relocation, ventura:       "66860aa42d2852c70fe9e1544a4bb381a82f8ce2c1a9a84c53e671577ffd392d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f7e036488c7d21c0a9cc2c42731a2d7abd0350a438182146ffdd7156567b19"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    assert_match "Mount: stat test: no such file or directory", shell_output("#{bin}/geesefs test test 2>&1", 1)
  end
end
