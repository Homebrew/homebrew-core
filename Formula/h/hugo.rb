class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.121.1",
      revision: "00b46fed8e47f7bb0a85d7cfc2d9f1356379b740"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f10509e063b2f2443485afe896a0635fd6eeff481abe288c6aceec93ce2f9ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "386a9b90a03bf9442c9bb09af07e251c87eb9886826f8d1727ff2d9481285bc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "705ba2198152f344e16a589df37a750a0b09ffb4e529d15101d7c315d5b1d876"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b7b1a71dc256b630da9e6d1a8102d28843e2a327dd35970f2992a2fd35f19af"
    sha256 cellar: :any_skip_relocation, ventura:        "ffcbaba905279ed97cc5502136b30f181c99492ee46795662528fdd6b0387945"
    sha256 cellar: :any_skip_relocation, monterey:       "4730027d9cf4911a319d4f5b78bcc760450855e488fd031f8ce86bdf48eb4818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5805f549466d9b647a9741eb615efe774f1c5b6bc4d27eb7f7f8a8b3a37f3c52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
