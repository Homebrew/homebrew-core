class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.12.2.tar.gz"
  sha256 "c9ba4e72279e27213395d3c238c4e3764c72f725d9f0057582113a6868337a81"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e99a27f2cae71a08814274fe74c36c212098d47a43ac11bcdb15aec7f3591503"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af29e070c7f93b86fbd84b75bf5f48fd40f79a1c61faa6727eb2834c1456c4f8"
    sha256 cellar: :any_skip_relocation, monterey:       "825061a3682cdb4efea72650db7f1e789d8e3566b57bd66c965eaa3447ff65ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ea3f4d33f29a82559317b1fe7eb7df9ac75da8394092c338fe2533cd4cda231"
    sha256 cellar: :any_skip_relocation, catalina:       "e6c0aeae941168abc2e7f8a177f6260eef21c2db79e6b019425665a5886d0cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a104571fcfc2fd9454f1b7ca66918f335a2339980b9ae10ea70ca850fc447803"
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
