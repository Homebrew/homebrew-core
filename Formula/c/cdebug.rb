class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "f038a96c4b022f928829442944f9d342d2b885474667c3e98d5c1d2b46337dfa"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16a334fb41d0f467f8597cdadd17d67f3b34a3aae94bfc7a8d845f082422cbb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7beb242b84142d56e98ef0a3a47f8ce02ef8f9d81818c9fa6c0b1b6262a3401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddf112f7c9050d89fc2a76b3869cb08fcb1a3b52b3a848e6d4f825d4254ab0d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "dae0dfab89a60bc86335d2949dafbd4fd4fbe643f3bd0ba45e7c698fe996fa91"
    sha256 cellar: :any_skip_relocation, ventura:        "44abff8207050bb0a264dde0c4c1a0a5789ebf898203641090c2a290a5cb80af"
    sha256 cellar: :any_skip_relocation, monterey:       "89bd6ab3fcf425da2cb013f412fdbfef45352de58bf9dcb57a8128e2384b0b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ef7c5714c668b7727d8f1f5fecbcdc618dcb9535f99e42c4a507baa9ffb277"
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
