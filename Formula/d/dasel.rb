class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://daseldocs.tomwright.me"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "55e7cbc95bfea8197dc79a2f8683aaae6502a2d9f47bb5740af088d34bc3a90c"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02e5d6af6795005913c0a65ca4096ab9fd576f778e2f3959ab662b496424e1b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02e5d6af6795005913c0a65ca4096ab9fd576f778e2f3959ab662b496424e1b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e5d6af6795005913c0a65ca4096ab9fd576f778e2f3959ab662b496424e1b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "292830c85c32e282f748cd81fb3fea90d580f52723f2594ecb175b9c65bd33ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a451bb9a98ca35cc888cb9b5079eca332f573d2f44ea5f72bd4ebfaea7b13438"
    sha256 cellar: :any,                 x86_64_linux:  "9900818e35d08f3bfe8439bdbc88a768e46ade41467038a6e1f06874a3461837"
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
