class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.9.tar.gz"
  sha256 "1bfadc131d1227b7d5d72ac36282bdf1edac85a9c5ecdfa4c5f923ebdae2cee2"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76c50afaed0c9449571cd30869fd7af682ce4b904d090b0b3a33d95ac75e2194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "929cae5f62efd8c6d9b432b310c338908d82821fd8e667dcc2c26d1595e09f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1575af93889d6c92847c0c9df9c58ab77490b57c12ff6a4b2da1f934847e8c67"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda462bc2c013f1ed5ba732184b234fe10d98273d1922deed8db8d44d894392b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e722516e74504df275c56ec240f93b7fa5048563338cd38ef8bade3d7c34b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620a1d1c0201288411ede64b49d02a92d49d9966ce6a4ee85b1b03c208a1b166"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_path_exists testpath/"opensca.log"
    assert_match version.to_s, shell_output("#{bin}/opensca-cli -version")
  end
end
