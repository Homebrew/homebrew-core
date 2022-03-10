class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.23.0.tar.gz"
  sha256 "ffb79f965269f1c34b0c2bf58ae5abbdbcbc71fd4a8c2dc09692db190128c8a8"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "943acac1b078dd41b7019f3df90dcb9fba852c077d0ea86d564b7b6e2d1c53c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c6a8f17014cfc1f1e78f91914c7fabca627c3322a4c7688fb58bf7f104da148"
    sha256 cellar: :any_skip_relocation, monterey:       "ceae8ec5712edcfd72e4eabaa5cd3954aecdd1d271bfe151b71a10ee50d59264"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3c36d5e238135596e37f33c972cc726812f4b6dcfbb66e7904f7c3b93f28f28"
    sha256 cellar: :any_skip_relocation, catalina:       "f273fd5ff9520c1f0fa3f823a9597d129d61793363a79f87b07e3a44985c2032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2e145d365441ee2825d81a8d64d48e73fb63e0934fc1883633a2c1b5c9cd87"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
