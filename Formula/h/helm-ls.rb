class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "098781469caba5783c51cc17ba5d026e0d666a867ad2a59b6994f0d1ece97a72"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61cb565d4e4b1d228317e0b8ad4a04cecc45d2bedc36124f48a79c576b9ca059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef92adc9b8b528ad2b7b854394173ee92cc132fe9eece85c508d0a16542849d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2dead86f308cd7837c2de73f57efe2ae3ecf301bb3127a9c5f99bcc18cf8381"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b83789258ebe57d6ec44b527d27da12b1b1e0e2bf53b99b89817ec136398d61"
    sha256 cellar: :any_skip_relocation, ventura:       "0595aec7f9a951c496ab97dc047d669770bbb8186816d9018f29fa9418a6aadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9dc986a184140c80f19aa16fa54f905f84d034ed98ac235c2ec779aaf59008"
  end

  depends_on "go" => :build

  def install
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
