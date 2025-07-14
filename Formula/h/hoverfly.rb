class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "9af2cb245eb3effb0cad97bf0feca8b5b2a48b3565c57afd47c129a2e8e32196"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a59bd314750a52eee309ceb87b3b735256b72cd9fe82bb8d1ae07a83139f51bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a59bd314750a52eee309ceb87b3b735256b72cd9fe82bb8d1ae07a83139f51bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59bd314750a52eee309ceb87b3b735256b72cd9fe82bb8d1ae07a83139f51bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d4126ad0a90dbf4285a56eba5d526695ffdb7666ceb71acdba2c61f0e158d7f"
    sha256 cellar: :any_skip_relocation, ventura:       "1d4126ad0a90dbf4285a56eba5d526695ffdb7666ceb71acdba2c61f0e158d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9f50f5ec13d9ba260fc87715c37a11acabfa794b306e2ed1afdccb342aa5c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
