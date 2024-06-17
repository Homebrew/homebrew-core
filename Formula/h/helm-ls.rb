class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "a79038ea77bfd3130014fecb52ed13168df8e3ed5f1289146a47500b81952658"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ceab9b3ef2958f0e2df5cdbb9ff9e51dc71f9f78b38c58d8b3e81a4908b89e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f98bdcde50bef94af50020639155f414af11901fac9f21e26daeb4fbe7affbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53d3256957695335d7b1a0cd0ced2a89be6e96c393e87b8a2e80925db27dd07d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7b6f0e3d2c3f28e51a7c946ce38810a7e5e29a1a184388d913bd130886b9201"
    sha256 cellar: :any_skip_relocation, ventura:        "b65ce34d43085ffc5f45fea62e99df6273877bc2fa00627d26fe46aaf57d1f29"
    sha256 cellar: :any_skip_relocation, monterey:       "52e8cd71b073a3a59b5ad1c3cd057a6c52de924b74ec3b5978abf97ae47aea79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "520d068062ad8571ea0fac735856219ba6c3f6adadf20843e6d16c2aa4639c56"
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
