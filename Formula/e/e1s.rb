class E1s < Formula
  desc "TUI for managing AWS ECS, inspired by k9s"
  homepage "https://github.com/keidarcy/e1s"
  url "https://github.com/keidarcy/e1s/archive/refs/tags/v1.0.53.tar.gz"
  sha256 "1f99a3fb44fb784eea7a77aceba7730efa8b0cdac4f1095eebd7be8e355afbda"
  license "MIT"
  head "https://github.com/keidarcy/e1s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "956efa09d22006af0d594aa4074f5d56a59f59c98b921c2a11b5d178227b4deb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "956efa09d22006af0d594aa4074f5d56a59f59c98b921c2a11b5d178227b4deb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "956efa09d22006af0d594aa4074f5d56a59f59c98b921c2a11b5d178227b4deb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c26b95f97627bb02af628d243b2b30d9ccc88c0dfc1a6b075ddc64dbf6dc21a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d82cfca717d176b42ae9de03ffb5552f4f553520fb4fbf81fdc28b8888dcc900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954696ee65202bef01a079757c4ed5d3bd8c9bab92f9054b48a5040776df453b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/e1s"
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match version.to_s, shell_output("#{bin}/e1s --version")

    output = shell_output("#{bin}/e1s --json --region us-east-1 2>&1", 1)
    assert_match "e1s failed to start, please check your aws cli credential and permission", output
  end
end
