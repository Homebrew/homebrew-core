class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "4274f6140b9d1b6694a2453840a7108bb6964ad65b980925d0c994e28a431f3f"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d66391783a4c840bd993e3ac94f801da743950ff88eae5ef924696fb6d0548fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44386323a2b6d10246acdf544b2848666ee8e5adae6a48cf407bf3300bde5a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ae7c58848dcf2623a9d02bb9909d91bf3c5c57ca6424a85e19f517b5f9cc567"
    sha256 cellar: :any_skip_relocation, sonoma:        "33bc660c2c335927d214b5375c83625b16ebe33e27f295bec16e0c2059926d71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bbd9909240697985a1e988c0ca38b6f7eb179c7b6cf0e4264b822cbd923b6d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1f1d18dd85dd323dff7fce82347df8e3dd890bfabbe6f73aede42838b6106c"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn Formula["ollama"].opt_bin/"ollama", "serve"
    begin
      sleep 3
      output = shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
      assert_match "No matching models found.", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
