class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.45.1.tar.gz"
  sha256 "bd9a137a0ced94f6b0baaa17205f90de80fcbe389946cbe16a3820c3414a2b81"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac36d128363d885d97991d9ff24b72b5b4d686aec63c8ea6bdd7265ba1132b79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2878de146683a34908f9637441b6e7661c1a143bbec6a852cf98b700728fa9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee984a7fb8ed29740260f84fa8b5982f8cf0aadf36077c8bd0ce02664604db32"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0efe227ca71384eb8c2deedf888c522143082d020700d41b4c44949d31aad01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64914dcf85e5fc8f8de2795bee63717d79ca3144a7f1b7ae6b9e6f721376155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b73617e33c6033c0eb1f4371bb7eefd085903ada0db8f0a15ebe1fbb4a078b6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
