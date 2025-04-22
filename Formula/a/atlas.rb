class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "ff98411fdc6f3ada403e6a614e7e599e10ae50d1431712dc079ed4e1168afb77"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c9c6e73261d9a2c91a2da8735deb2f9547530d96812783578d8352aa531dcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb1a494bcacec92d8864437a0092e38d0a84712b0e61441168c7fd8c9632e3fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2c9c2d35d6313d647b225e9a49a84103288d8d29a5ebbaf68d9e839325c4503"
    sha256 cellar: :any_skip_relocation, sonoma:        "514788a6551d3b836090c66f3a037492b44ac96efc05d44cbdbd95f1cd5c0d9a"
    sha256 cellar: :any_skip_relocation, ventura:       "8fcc19fce99d664d6d74a7d2c7ffbcae3ad558ac89c2df3332d74cd5b6ac25ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0722b77faee8739aea8c23b6a45ff3b13569630acf45d083ff3bec46503b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4efe215b6bddf9d353fe78b9ad28c3eaaec8efef1dead75f3792ddd4b21df91a"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
