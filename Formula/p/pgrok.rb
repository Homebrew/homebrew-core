class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e0dac3df791e9727c850a18874c7888544b548345b27a1a94914fcfc10f05e9c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf15fcb2cdcc2f5be2f04781be608941f86663e90d3ee1ff48d970281263aa8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf15fcb2cdcc2f5be2f04781be608941f86663e90d3ee1ff48d970281263aa8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf15fcb2cdcc2f5be2f04781be608941f86663e90d3ee1ff48d970281263aa8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "68efbbd93c7aae98d6cc6a0c15f8cd4dce013eac925aa8d482eb2276e878ad32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419e8c45a8430f1b6c793a8e7ad3e5dff7d539e3ff19b6abb8ffacdaca86fb45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e303842681daf112dc720aaa3d091096b5e5cb0bd6771a42ad9d84ea631487e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./pgrok/cli"

    etc.install "pgrok.example.yml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    system bin/"pgrok", "init", "--remote-addr", "example.com:222",
                                "--forward-addr", "http://localhost:3000",
                                "--token", "brewtest"
    assert_match "brewtest", (testpath/"pgrok/pgrok.yml").read

    assert_match version.to_s, shell_output("#{bin}/pgrok --version")
  end
end
