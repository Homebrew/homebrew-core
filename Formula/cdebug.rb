class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "6fd0b8ca494f7f6b1ebbef23af5f909fd073e9cca06186aee667c7b0933b199c"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "121812c3c70d4d55f87a273c21df5ab609501d9133a9815710b8bfaf07c50f7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "121812c3c70d4d55f87a273c21df5ab609501d9133a9815710b8bfaf07c50f7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "121812c3c70d4d55f87a273c21df5ab609501d9133a9815710b8bfaf07c50f7b"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e7fa5f8c8b465d45794d96e7af259d5cf49d2a445aeb2d30ffb22131dde75c"
    sha256 cellar: :any_skip_relocation, monterey:       "5b4e514db5f276dc5bd9989e38b80ecb424c2f21a9668799bd88725c66a223d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dd6e224e94707fcdfeec8e960e37339c6f99217c3c520e33c7a7845bd3a05af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc04ffd4efdba6bfe11e9a6205aadb387e54f662d0399c7ac3954d496ac93f15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
