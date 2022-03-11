class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.0.tar.gz"
  sha256 "e785a4e8028f190c0ecdd628ee46aa8ac99baea87ad437098aacf12bedbca98d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca624245054272ecfdf9ae88bfc1456479e69960ee962271f586ed35ea05bb1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ca1b028a240e0d237b5322478e557aba77118635947b8653cf7dcf0dfe220ff"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3a5e40d3b3617457d8148f7cd2b089baa90907fa7b35b675c8fd1b9c5673b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "60bd571a7e6cd22dc1ed2e91e3ba3e72cd449a47efc98c5cacd736ef4ae4b606"
    sha256 cellar: :any_skip_relocation, catalina:       "d4f2c5d7dd76609499c48a54d1d992f4159fe6f023d06e86557b40288d941280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f590a519c3e4593d1e61bc81e83fd78eac1c228e59f3d9b775fe836bdeb535d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
