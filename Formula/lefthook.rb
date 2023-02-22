class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "3a4cfb0a37b8b367d2e6264052d03e68f91efc4acba73ec52ffb5f701d65a77e"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0565208b037380ed5f38ad1a7893c7e3dd65c455b56a17012d51be63c280d6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df943d0bddec1fa9017eb2c8a10e016afb34995f1eae9933ff8d7196fefcf992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eacb82e0246504f106a6f31eb1c9dfa72eb44c6072f9cfda74c72a1eac1d0cc"
    sha256 cellar: :any_skip_relocation, ventura:        "a8e1e6d07eeac04aaf3a8049ccf1d16aaa5db93e5f1a9f568e1381177956ff5d"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f47e7aed62c269287708becb2dc5ba2381afff3a47ef425afe43e3dee9f026"
    sha256 cellar: :any_skip_relocation, big_sur:        "01d319d5fb0076f0333a51c854a568bcc032ff689206be9527af489379fb8986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8672c9b7775598be2f88aee8381109ebf8d23c0dcf2b9d75a46597891fcddcf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
