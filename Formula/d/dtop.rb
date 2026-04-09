class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e3a21fde14497c97f98721ae24c8334148f48bd3eb5f08b6a688bc018a360cea"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b60f06e8146c89ad0e1451e41b86b6c3198acca6ae5cb6fb73a32fd3b6c3525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e1f9a20721093d8f5f1c3a458163919118c8641b2cc649b17a00e5496f80df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415b586e8dcc10a4a59ba0aa8885fe7591058efb16f7530174264e089f2560c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2d591bd89827906c868b0443f733177f188f7a1453f8f0dd1f2da0e78905e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f60389498340a23338a3b10ebe9aa6cec6905bb5d70ce490664094d0424958a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9677ecd056b7687b639d1f8df8ef7f691060305db2bca40d68ecde97bfdc77"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
