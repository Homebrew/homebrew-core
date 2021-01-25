class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v2.3.0.tar.gz"
  sha256 "6933f9cb826449a456198581eeeff37ec257a33098748b514937106ff74f885d"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f7f7bc4090b60cef5e30c70e12b476e7664e7c4910f49dbb51255d4d81c4050" => :big_sur
    sha256 "18a0a07a3af24fa74b4590385f297441379005a0e4e3f6c79895b38c5cef6ccf" => :catalina
    sha256 "b8da5a81c66d27b82d8e604444dd31807b4c567e73c8c80a84704df402e6ec56" => :mojave
    sha256 "8e7bf6bf388b11ebcf78a0f6442b2dd2673ca7e99b93282f59a38103e2ee3293" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
