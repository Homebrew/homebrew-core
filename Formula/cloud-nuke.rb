class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.8.tar.gz"
  sha256 "b766b514c533c83e63feb3f291c5a426e71d556f9ed347e7aed326f02069dfb8"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f173bdf23e8c038b44efad0ea749b001a7829b2fba2ffd48fa2428436b114cfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6f448ddd7509ef92f07455fc97e5fe1dd4b45e71fd0657c6c634f70124f65a3"
    sha256 cellar: :any_skip_relocation, monterey:       "ee6a32bb63b9c00c91dd241b09d57b67d48fdeed340cbca6c4cb1e0a783771da"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f273276da2504dd3cba09acb49586f4c57f6657535a2d573d8a07348b62cc9"
    sha256 cellar: :any_skip_relocation, catalina:       "93e60560b4978e7435f1ec564c7942c9da0fd3a17ef762ba2dff61058ab9aaab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d5a62b8a3ec9ae53ff62a4a8cb22274bc1b61ec17bd6e70d8d86c0ee93e6f9"
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
