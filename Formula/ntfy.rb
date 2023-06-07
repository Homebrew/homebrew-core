class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.5.0",
      revision: "df8b18bbb18f6140414351d7237f5caafde8290b"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93fae6f3486fd1154860a6be5222cd63511962f05ef90e15bfa97d0b72549de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93fae6f3486fd1154860a6be5222cd63511962f05ef90e15bfa97d0b72549de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93fae6f3486fd1154860a6be5222cd63511962f05ef90e15bfa97d0b72549de5"
    sha256 cellar: :any_skip_relocation, ventura:        "3191fa65e5ca832a7e877f993a40db4efd24fd0b3134c0bfb3344c1e0b8693a8"
    sha256 cellar: :any_skip_relocation, monterey:       "3191fa65e5ca832a7e877f993a40db4efd24fd0b3134c0bfb3344c1e0b8693a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3191fa65e5ca832a7e877f993a40db4efd24fd0b3134c0bfb3344c1e0b8693a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216120390f130eec8b6c6dcf602989edcdf8cdc8a9003919ebd47406ff32ef58"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.strftime("%F")}
      -X main.commit=#{Utils.git_head}
      -s
      -w
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "noserver"
    end
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end
