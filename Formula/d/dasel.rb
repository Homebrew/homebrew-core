class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "4711deb92e3b6daf65453244559cb6e718041b5673f76d5dfa2aa4584e38e5c6"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c11abbfa490f82138b51488f108e09b2f163dcd5a0ddcdd40163a7185f66b54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c11abbfa490f82138b51488f108e09b2f163dcd5a0ddcdd40163a7185f66b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c11abbfa490f82138b51488f108e09b2f163dcd5a0ddcdd40163a7185f66b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4aad3de918699b4ab9af6a033f9f4b1329a3421667f67dd657b59e92410d294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b15571c4385beb9b828b916b6cea1cdbacff661c74f8e9d2fb48754ae90aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "967aa3cd2c6ffb85abea361163d95d622fe0f321dab7f499cae174ec79bd3b9a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
