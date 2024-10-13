class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6cbbe74114e6a4b8cd0821e372190f67743bb0528ea364a969524c754ba00c22"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8036353a79e05dbf8cf9575683e8ebfe01f061c03d47494d9a8843c949ca297b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fedd5ab71b9056b1e72dea7cf14793a3f031749abac67ceb8ea82562a14316ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b97bb39daac8453d8f743d3d2157788c2a98d975c0eaa4f8d4bee296583b436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cff77a1eb4bfba6811d7c0874a48a12282f22ae041ae45030654b1b36dd1b2b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "18ec922131749e79ead6a293f7f24e46c40381843a6569bba092ccb392176652"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7c8137569c772d25e34d98f723519db292329706a8cb9042893a9888c6b8d9"
    sha256 cellar: :any_skip_relocation, monterey:       "db62edea9ffe0fcfb5572030a136d163d3b8b8c2233da4bb1b8b9eb1a7c800f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b8c65835838e2509815cba6b3895e940354df97ac376516b809d7dc1d01710"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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

    assert_match version.to_s, shell_output(bin/"helm_ls version")

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
