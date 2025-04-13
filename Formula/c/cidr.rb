class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://github.com/bschaatsbergen/cidr/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "caee614f119ec7383bc9a9dc04a688b4b058d15106f70f523d04c8773d2fa086"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f92c6bdc12d20451f4b3d33a119c6d446945034759e752fa265594b92b8a3c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eab28e7e3430c08a756a465845307c350e54665c082faef4d0cfcc9d1718537c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09b43bb3087a8b2967efeb81e55e589054bf9d72b9418816db0491399d1baf5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a052f10efcf19df9e0a41c035a0c9af03a908d515ba713f3c978da1e9c5daf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f2df01b413b882817f5b975553fd0043f7fd6e48167ea2ae680ebb905562006"
    sha256 cellar: :any_skip_relocation, ventura:        "58cc2209eb5323798a67011f41433ce5f4641b2b4f2cdb2013b5ec1eb7d873f8"
    sha256 cellar: :any_skip_relocation, monterey:       "63c22da52ab9c5b7e7ffc35821ad1cb76596e071f1e412971a4efa60a0f9e9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bebb8b71e94081655b343967ec6d56e78daeee550a60dd75bbcbc50d45a3f9ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cidr/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cidr --version")
    assert_equal "65536\n", shell_output("#{bin}/cidr count 10.0.0.0/16")
    assert_equal "1\n", shell_output("#{bin}/cidr count 10.0.0.0/32")
    assert_equal "false\n", shell_output("#{bin}/cidr overlaps 10.106.147.0/24 10.106.149.0/23")
  end
end
