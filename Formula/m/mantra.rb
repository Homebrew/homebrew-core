class Mantra < Formula
  desc "Tool to hunt down API key leaks in JS files and pages"
  homepage "https://amoloht.github.io"
  url "https://github.com/MrEmpy/mantra/archive/refs/tags/v2.0.tar.gz"
  sha256 "f6eecb667fea6978cc53e8ff0f18f86b6ea6e25a651af24d00c941bdfd0c8ab2"
  license "GPL-3.0-only"
  head "https://github.com/MrEmpy/mantra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a53d93d65ced3c59f29695d6480b91651e866b01a7858aa6f748389e02fd0e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0d0e35be8c8c9bb772cbd486fa108fcf4454861c6a025ad0db15273dc57c73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc5e2eca313a3583f9ce1453b229b46b01ede7d97a984c258fab50e195039814"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4c9bb02500093b2a41ffce55b75a6fdfdd3b522366c4e4f6dada9d94cbc5b04"
    sha256 cellar: :any_skip_relocation, ventura:        "0b5d253645f863d03554c0fe4ed3fb2d1bc8f1b8248289e7cff6d28c542464b9"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc954f6399c3ebc4cbe352c295c0a92a2bb3c649edf98fa965bbb2dc5297eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a18404491b344866ef5a92dca510b02a79da2be1f87f6627d180da3e2bc3456"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output(bin/"mantra", "https://brew.sh")
    assert_match "\"indexName\":\"brew_all\"", output
  end
end
