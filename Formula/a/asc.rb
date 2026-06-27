class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.4.0.tar.gz"
  sha256 "7beffd0858b7f1feda5d83553303118ff98c94ec09181aac4be14beca740bfe8"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8088af4d3fc73dec3d5a68c1eba84ed834d6fd652c723a8bace771e1bdf6420c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd8b4f800add473b55ddad19ab394f7c454d40b7cf2783802067f76911a34e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d98e2ca0ee87fa9c7b79f6f93a310df7ff4c64819f70ad4c600c4bafcaac594c"
    sha256 cellar: :any_skip_relocation, sonoma:        "683ffa1ead7bb8baf49c99b15c755b37ce87ab50a490b16985230faae51e5410"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0762a888b476fca64cc58e9a69ac018fd4799d6ac2c91d94f3efe4ec13e21192"
    sha256 cellar: :any,                 x86_64_linux:  "e850c9f0b85ce28e1e7bf1ed9ed8a28d8609fe963d1e4039334c7f5d06e857f0"
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
