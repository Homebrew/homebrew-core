class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "900bf7481c15c4f2be73835d079f4234cbffb9a8d8576527f680997b47f7bf46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10887c0cb68219074b5ef4f37fdf45393dbbeae1187bb93e5e167b1245181889"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b698d283b2c4477da04a8a9691eeb8fbfa057a5725a47d60e97a2d7fc4563d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb39d71f0f1f77e622e20550f027bb574ac1c1627f15ee310e77959d945841c"
    sha256 cellar: :any_skip_relocation, sonoma:         "607852a8629be23d5b2561531c981da0c85c65cae237793f62c1469c983321f0"
    sha256 cellar: :any_skip_relocation, ventura:        "b848a844b187e45d672e14152c8cc613ed0aa23d813832011597ba8c591f620e"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4cf5a396339f32970a777b21a87293111f413160bdbc27e2005f3998ebfe3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76adeb1791732c6924e46149d9aea5a808b6d0f2cf92d381ea40f3677e9e7d29"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
      -X main.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Invalid openai API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
