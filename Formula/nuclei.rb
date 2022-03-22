class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.5.tar.gz"
  sha256 "b3751ddaf3c657d5902d9ec10db221ebed9646220fe47fa2f3d978b091f9dbdd"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2f66e787f1509337038947393e54888859db081fc65a96a5bbe7191dc0be010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f83bfdcbbbe0ddf493e995ce0b403287e20708fd0c54dc69399069f4ffc17fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b906f15252a48091a92559eba6d66a1ba23f71e6427d2c99470cd02fbba65169"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b9a2e3bc1d7fa9e360efe4cb92941bed72e49825576b7e218903c867dbc6eaa"
    sha256 cellar: :any_skip_relocation, catalina:       "7351145a2c9be9a0724e9e175cafd0625f347131dfaeada8f97db9c17a4babfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc48f3f5c3c79c517078bd814cc08bef44bfc9a66afa8653f506a926119ec84"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args, "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: \"{{FQDN}}\"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - \"IN\tA\"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
