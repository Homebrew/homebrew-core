class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v2.3.0.tar.gz"
  sha256 "6933f9cb826449a456198581eeeff37ec257a33098748b514937106ff74f885d"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0db7ff023c0be59803cb2d7e4bafd73e5b582b55b5c11a8bca7d24cd1697747f"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f7f7bc4090b60cef5e30c70e12b476e7664e7c4910f49dbb51255d4d81c4050"
    sha256 cellar: :any_skip_relocation, catalina:      "18a0a07a3af24fa74b4590385f297441379005a0e4e3f6c79895b38c5cef6ccf"
    sha256 cellar: :any_skip_relocation, mojave:        "b8da5a81c66d27b82d8e604444dd31807b4c567e73c8c80a84704df402e6ec56"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8e7bf6bf388b11ebcf78a0f6442b2dd2673ca7e99b93282f59a38103e2ee3293"
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
