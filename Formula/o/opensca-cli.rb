class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "d28cdbab3e0aee1b4107a7d9e003fad6603dc145171a47079084f23452731fe8"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b747404b0ec47f59696e1a7a7b783d4f12245d40ed59fa7113bb63452e4184b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2bf0ba81f92faac4b0e76015344487cebd53da4c660bdaedfa63cc002e4a26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8273d141b75fd503ca405a73eaead3ea5c677e08433a2b91060ceea02317acc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67c7852691b7ad40296d4e7c328e150e6ecbc97db4057cc027bb6a2b1bc6a590"
    sha256 cellar: :any_skip_relocation, sonoma:        "86738a46a09bebd72eccb7ada0605f7ef8f5f8d3d1f1566056f9ed8c734ea0e5"
    sha256 cellar: :any_skip_relocation, ventura:       "baffcf7508ed41b2883eadd7150c57bbde8b69e99ff65ec4f578fa6feef16ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4149599471f39aca06d965af7b59250998098097fb5b9542705e9c9015d2108c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04bfd766ad0375c92859e4066dc9b81247f2e6f8f2a916cd1b0eaa4cb5d07511"
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
