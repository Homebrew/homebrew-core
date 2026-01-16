class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "e50dad38aeadae56cec7ee8077e8b701678271cd425c89668b098265250d5b83"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f0db93dfa82b3173039a26f609cde4d41da84b212fdefc73d56d9f29b5bea0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0db93dfa82b3173039a26f609cde4d41da84b212fdefc73d56d9f29b5bea0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0db93dfa82b3173039a26f609cde4d41da84b212fdefc73d56d9f29b5bea0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad6785ba172ae40190f7807f58d99c48f483fdd1e0dabf00fb9d30aead030778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "babf6c69cc1ad84f634e79a942203d281632f0d7925dcc557b21e3d9467c7867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864871b37502db5dd43df949c840512c23b3d278380726a34172a4823ca63296"
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
