class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "57414ab5fc6ac33b37b966f264a220131a2f6c9057d4f36d6e64ed2866d95fed"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51340c8961e74d7860e819665afa525e303d13418d2751694a1c2991ce3ecce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d0f33bf2920d7a49f7625ff96efe7427f1b175ba67f6b643af8b79a3e454a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7220b9642562d92423965170fb9c358b080294e58294aac81f0bd9abcbdd0d61"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7a52541277393a36822e6e336e950225061ad4bc177e8b0d3f0942a15350010"
    sha256 cellar: :any_skip_relocation, ventura:       "231771a00f0c7fa4d5a4ca2dd2be9fbee5534302bf83af2e57c4e91eec4dce80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69db31d5057b0ed7278da420be21bc6335f0fbf017a1f794ddd27056569a26d7"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output(bin/"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin/"gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
