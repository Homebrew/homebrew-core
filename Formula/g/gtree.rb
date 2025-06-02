class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "1bbcfad89f50c02664f6a62094f52a98b08f983d320313b9c3f0db71b4740692"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094c89bcbb16b2f1c0d1841755c0f930b52e488df4cb62d8ab20b7f5967baddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094c89bcbb16b2f1c0d1841755c0f930b52e488df4cb62d8ab20b7f5967baddc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "094c89bcbb16b2f1c0d1841755c0f930b52e488df4cb62d8ab20b7f5967baddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "765efe7fb65211129c63ae43a9ab49c3ae32fe452e8188a9e1e8cc7ea9366f03"
    sha256 cellar: :any_skip_relocation, ventura:       "765efe7fb65211129c63ae43a9ab49c3ae32fe452e8188a9e1e8cc7ea9366f03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a75672e369a39fc4bb29025e25fcb83a0345e32a3cdb3b9bc54b4220d73bea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ec1a7be0997235c44667dfc070b8baeec9b8496a0403f4777786d4a360dc51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
