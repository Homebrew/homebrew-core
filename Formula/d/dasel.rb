class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://daseldocs.tomwright.me"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "5471fe33b28c98efed2b1a13431ed24097785f56a24dc9fb15e37b1e266446e1"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b23b22c84b8d83259e490e327ad55155c0f988dccec71f2180ae223e7f91d89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b23b22c84b8d83259e490e327ad55155c0f988dccec71f2180ae223e7f91d89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b23b22c84b8d83259e490e327ad55155c0f988dccec71f2180ae223e7f91d89"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f33ffaca3dcdd37dd8a71c28f35bf1d7ec5e05d5f071b261a5472854d109967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d7c070bc6b0b624299ed67ded281755c36d064df04d46be27ab0701f1391a69"
    sha256 cellar: :any,                 x86_64_linux:  "48dc0a317b09212e2c65eba63e888ab9259e34dab679723f771e89147571f6b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion", shells: [:bash, :zsh, :fish, :pwsh])

    (man1/"dasel.1").write Utils.safe_popen_read(bin/"dasel", "man")
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
