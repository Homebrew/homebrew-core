class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "6a8ac0c177721c8b2145763d57810d565bc84149251c19c914e348f303fac0f0"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aff6a165b7b1eef6cc0023b7cdd26ea1af45fb5648cc8a6a7bef1872a2f3b84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5efabef80c78af18299dcce4e17b1f85ce19904c8831fd0bb8be051d9010f2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e746df085a5cbf2c36ae736d3ad1ebda770adef38184622e7774222456160c47"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e30a2e97dadf5e81944ae0162c96f55847573aa172fb7476bf5ca7133fa522e"
    sha256 cellar: :any_skip_relocation, ventura:        "d9daffd642f2978031c5e08422a748963063986040a33438ae705bf2d7985199"
    sha256 cellar: :any_skip_relocation, monterey:       "2a968eabbb81cddecb6887dd56155fb10d309a2c06125cb3eb7079f1e2d99864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734b245ed3104647c3ce41cfdd119d951e6e2d33a2ce32c590b782bdc8924152"
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
