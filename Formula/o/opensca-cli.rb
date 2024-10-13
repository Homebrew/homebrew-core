class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "3efd767629e58c9f05682e5e843efadef8544861c1f30e80f334c0daa9bca4e1"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "91360c5d1fdcfa02c9463d380f7f38c67fdfddf1d17b90eaa08991209156c5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc3048f9e95a7e74fc62790f8add12b99eaeb457898eb4a2bc4b30797fea1c28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "515633284e6f6e764e03e8013f2dbbdaf051968e7b6953f705dca454714ca4af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1005d2ae0cca98a7f18b2c2dd446f958a8ed51cf7b81a4157f236aa71fb1b0dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce17e0b3ac7d4b3db854526d3ee07e18fce5a26c246b34d0946e1250337ac80b"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee93fba6ea28c36415e85e282693662333eb9f419d7445c79465b99d59de153"
    sha256 cellar: :any_skip_relocation, monterey:       "ad98af248ed82ba2556e9da245f5b23233fbe45eedb282567682fab3eab3d556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a4099949014ccc6efe47696861472027e7fd2f9ce0cf2c39737693e394a85c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_predicate testpath/"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin/"opensca-cli -version")
  end
end
