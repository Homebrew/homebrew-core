class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "ee4d8073f040a1cf182eb05ced0f0540b6a70ffd49187be3ed80c8f1290c37a3"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7dbd1241bce0f8c801c7d22fbf15847b5ffd57032cf781d25385d2fc3ece647"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7dbd1241bce0f8c801c7d22fbf15847b5ffd57032cf781d25385d2fc3ece647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7dbd1241bce0f8c801c7d22fbf15847b5ffd57032cf781d25385d2fc3ece647"
    sha256 cellar: :any_skip_relocation, sonoma:        "feec6b693ca372d211b7ce8cbeab8c95081d75277230adc148df006256eb9ed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f95a03a2a8f39b9ec7c3b317f82d5666d980acf4e707ee16fb7658079ed94ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35e4b40207bffdd6f93a7a38eb05c46d16a247e23c6cd944c6f2e237a6543aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -i json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
