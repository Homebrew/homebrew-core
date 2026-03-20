class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "48cc99e61aaef69236dea427665d76d81d3af3646ab235c2ce52b0f2aafbe66c"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "232f4179bfd83fc01a920d44c96024811893148ffeaa831ee0297f088fc10eb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "232f4179bfd83fc01a920d44c96024811893148ffeaa831ee0297f088fc10eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "232f4179bfd83fc01a920d44c96024811893148ffeaa831ee0297f088fc10eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26d0a417bf1a27d8c58835cc2a51602cd4ac79b5388a1d5e8d47dc60caaee38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5486378c9b39022332c3e457a9db6d8fb91da060c5370be5aae23169543a16db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc11da02a1dfa0b88a24b137c7dbc5c0b02c5af1a3e23300a0fb1bb39fbd2cc8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/bagel"

    generate_completions_from_executable(bin/"bagel", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bagel version")

    (testpath/"bagel.yaml").write <<~YAML
      version: 1
      file_index:
        base_dirs: ["#{testpath}"]
    YAML

    (testpath/".aws").mkpath
    (testpath/".aws/credentials").write <<~INI
      [default]
      aws_access_key_id = AKIAIOSFODNN7EXAMPLE
      aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    INI

    # Removed the explicit '0' to satisfy brew audit
    output = shell_output("#{bin}/bagel scan --config #{testpath}/bagel.yaml")
    assert_match "AWS", output
  end
end
