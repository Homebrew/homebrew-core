class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.283.0.tar.gz"
  sha256 "734a407ab65e52bacc1b1bb9c46a0b429ce65463d031acc28ee87c695f1f20db"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7c860ecdf8c325ebc0cfb643f44ade6572c444d55ea35fd64e3cde4147185b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db30cdbc9fdb671b9b7beafd2dc0420dfd7b18a85c842350e6891c64c14e673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11728fec8a0c887c3cc9b4c2114070a649c8fb16ed01c90c7f84ad3f17128ce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e1e8faa9ef4a95fede3ba20e1262ac51e9a35d3801424bc7f134d8478b49ea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e052c44ce6026d4e448033b4cda3c6831b92876fcdbcf612ff056eed9f44a59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6067b9d67e77ad6d2ae4c9265f7d58b058d30067327e8651af46cbaa8f45eb55"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
