class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "5f9122ce87e665a37e1644400b8564a600f6db39f0f55eec9d72aedb5c867c08"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "919f42541c908c62a60c840c0f26867c82332d237b5e82ebdf8cadb1684ef8b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087d894955e5ace72ca2ce2c2c3b3b5d6f76d1f68352db07a9e769bf27f9ec00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6965c254dfc62dc37fcfb3413ad6290f8390f5e3ad783a83195133c724a65501"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d01cb7bac65afcf2f9b997e99f33bd93823ecb3ce5f357824f5e232d561507e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f74c83ea332825549ff79daf04345787159c9aaa576dc6f6a918175d298082f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0750cda508bfdbfb22b97ffe80d5fbd3554d11e8e1d1938c6830036484e4233"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.ServerVersion=#{version}"
    tags = "netgo,production"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/go-camo"
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"url-tool"), "./cmd/url-tool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-camo --version")
    assert_match version.to_s, shell_output("#{bin}/url-tool --version")

    port = free_port
    spawn bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
