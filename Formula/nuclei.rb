class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.6.tar.gz"
  sha256 "45127c8b0d9c716ab7cc03af76add98141b3d449bb2edbd7bf0c6d4b7f1e1b34"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d31d5d95577175452dfb8771118a87d21bba3296e9a7815b4695b3f212d1f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55aedaf96e82f9636332a39b767bbcfc92f0c872f8074653c090e560bf919adf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "445cddfdf24c2f5486640c936887353d759adf5d7abfe80163371f18e5a08410"
    sha256 cellar: :any_skip_relocation, ventura:        "1f93d43cce2550776ffa8a994d4957a9ce93c550c82c692aafa93fe65a3e91b0"
    sha256 cellar: :any_skip_relocation, monterey:       "cd5e08aa6c0bbf9e29d9b830306f1081d768cad40a8c6a3daa49734175aa7d9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "10d45bb99a4f289d6dee9c0821b6ae593151749ad82caf3bd0eb8a499451c04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "facea2e917fe698d50e12dedf100b161eda9fba76fc2066885f320576d5ab98d"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "main.go"
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
        - name: "{{FQDN}}"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - "IN\tA"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
