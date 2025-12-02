class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "a8a5490084839af3506c85efcf603fbd71bb9ee37222bbd7817da1da3f054ab3"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34112bdfac9d66eb2ccd00d691751b6a4272cfd35e13b27eaebac29b561da065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7ca4321da24ac8caf711deefccd3f1cd694a9a47854db8c68d62f8cbd423b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48cff4a67ba23584fc0a5e36e5512d7cc7c1a04eee40bb72cb2f32369b2ccd64"
    sha256 cellar: :any_skip_relocation, sonoma:        "c73b83c2c8ef38ee905970b62ce99a9b5a24302449a077b43f14959437a88215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1d964572fa17d745a855acaa728e4fcb73eed62ce1ff7a59940fffcce4b5d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1b453332395c02d589b21d0c87a7146fdfb1826cbb5dd3cbfb95e8ec69e3df1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CompiledBy=#{tap.user}
      -X main.GitCommit=#{tap.user}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"helm_ls")

    generate_completions_from_executable(bin/"helm_ls", "completion")
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/helm_ls version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "workspaceFolders": [
            {
              "uri": "file://#{testpath}"
            }
          ],
          "capabilities": {}
        }
      }
    JSON

    File.write("Chart.yaml", "")

    Open3.popen3("#{bin}/helm_ls", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
