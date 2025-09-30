class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "ac9dab6c1a6111588ce9572ffc46351e8eda86f495efb9f25ed9ad7dc6f5ac82"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c494e6fd80f964a17b6f267c6c8a539ff1fcd2541d03fd424ba1c81a3b4b012d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373c1718ad869193e8052898edefdafd7f148402c52e40278ba79cb8261638cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef49ed9df5d3b02e086635c1646da9b6cb091f9de33528e24f05511169ad2435"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "422ad3c58512082f42a176927c5381a4e04389216c213c448974f66c52c7aae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "269e77f15bb933c7b14dd3ae92df72709e0cea2e91ad4c58ebb8d4e24a247f9d"
    sha256 cellar: :any_skip_relocation, ventura:       "30736dcbe2a9c3456b019cf2f7d2d4de6a079c5a627d002203a537ad85d8c6ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1022a6ee40a91870ceebccaf02c7ee9993c4466d4ca407420bcf1ac6c4c3cdad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a33b6a3204128cbdd386108af445fa195ba47b8d03ef5166582614af7943f5"
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
