class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v6.6.0.tar.gz"
  sha256 "69a5c709d78604ed9d21b5439b2fbae96e21f729d7d36f417d50348dc9fdcc81"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6315ef336fb679f12d36330f33eaf3478dce829eab2ad3739c84ee4731971b42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6315ef336fb679f12d36330f33eaf3478dce829eab2ad3739c84ee4731971b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6315ef336fb679f12d36330f33eaf3478dce829eab2ad3739c84ee4731971b42"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc7cdbc05d965096539880f0795d61ef44a828abdd9a88ffd77085f7fa683f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9357e560586810ff168c204dc10a71b239248f61722057d03f079778ec332f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc67cdc999e593f8d39d30e24a0763f947145498f2a09a6d1804e524e04d5d4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit version").chomp
    system bin/"chkbit", "init", "split", testpath
    assert_path_exists testpath/".chkbit"
  end
end
