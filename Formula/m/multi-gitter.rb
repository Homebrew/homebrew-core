class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "a5fb523d5bc53f1526439d79d45770c32596f7a0a5de4dbbe53ea2ab47494e7e"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a6b08b1ce3221f66eeae7ac47825bd859c6643bc867779515a3edec5e4218db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a6b08b1ce3221f66eeae7ac47825bd859c6643bc867779515a3edec5e4218db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a6b08b1ce3221f66eeae7ac47825bd859c6643bc867779515a3edec5e4218db"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ae4e5b447e47aaf60d67c55ec876d78414d4958a20a703c003a96e9df578c29"
    sha256 cellar: :any_skip_relocation, ventura:       "3ae4e5b447e47aaf60d67c55ec876d78414d4958a20a703c003a96e9df578c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e6cf8ec9f2f8039dedb212885637778aef83830c25cabdc42672fee664842f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
