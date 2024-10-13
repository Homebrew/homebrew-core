class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "6f1459b80d98c2d4ebc3f1bf025b30671fb93b1b0e457d609dc5b718c7ced3e6"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c45f36e5ea025e82731d853ab05ead81ed7f214e87fefa46c4402a57463efb12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cb38b790c0fbc31648625a19b166089845ddaf8879fe746c3fa70c88d0de8a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a85309975e505544f0bfd3a80fea817463c3c859bb55610300781267005ca31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f7fc7e6ab6af42a32ea004e8bd5f735da517364a034b9721a6bc6bc22d7cb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab5fad785965863223212d9c413737bab66c84446a7baa8d7d0a5eb76dcabb72"
    sha256 cellar: :any_skip_relocation, ventura:        "02fa8dcdf73bcfbfdab1eb7df5cbf488829aab1ead948c359e783026ae1665e2"
    sha256 cellar: :any_skip_relocation, monterey:       "54cdbb948add4b80d20c94eaa0fcb04a52e2c874583f187feba95fdf668e3ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e199ab0fdf72ca39fdbae1f83b51dd59d73e77fa011c46746108fcb3cfcf0511"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
