class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "5d024cc4145da69964b35972e211dab49f59107a3564824921da674df1ab8aa9"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "217887f4b004cb2ced0f1acd39b9655539e9abc6311509ee2dd34444f30e857a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32adc72848331b660def53e7080e58da6f81b6cf7a213c2de48c7d25b6b00210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8dce7ff87886371a2863b56ec6ccd504e77c113bf26105c60c47f0f761e520a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9a72a7ef6e1712cdd8985f6811664502d97fc32bbf72e28eb574be5c1717721"
    sha256 cellar: :any_skip_relocation, ventura:        "755c0f94f7fd1a884a0dd03f957d0005e63b52c03e19b713073445e1b6904a45"
    sha256 cellar: :any_skip_relocation, monterey:       "97af63022dcd3853ad3b42385681600900420435310706bb588daeb442e7959d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730e239c455b50002a01de74c59a56798768d483664d9c93a6f3275422e2c749"
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
