class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.8.tar.gz"
  sha256 "a73664f2bbecf7e5190c65b99ec7da1fd6fb28c0420be8aa8682cf78b782a323"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4f7ec8955dd64e27e1b2a1b9cf9bdf5e5e01cb0c9716834fabf93cf87802890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "730efdedf8f6728dbb57270f6aae1cbd53bcfc2af552e763cf67e61374209abe"
    sha256 cellar: :any_skip_relocation, monterey:       "46d47b78e3137595b4cc24572ba5ea4e504e4eb9ccf75311262ccb55227f827d"
    sha256 cellar: :any_skip_relocation, big_sur:        "17c340f3f4d4bf8e92a88764ba732cf5a8897c1ff9866ce5cb9ee3c7ff5771fa"
    sha256 cellar: :any_skip_relocation, catalina:       "68f2814530d6fdd1c363a2a9eff9e774c9d28abf2cdbf99e386facc5246e5693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4f2288be9c0d82f9b58919ac255bf3714b15efb8f1964c298a9b093cb25c5f"
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
