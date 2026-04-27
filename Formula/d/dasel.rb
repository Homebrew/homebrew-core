class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "4d09e057c379d9d629e076752bf9ab9f7fab7a48712da4b73a655ea5157246b2"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dda2f38c0e470f9fd8c8b8b087c91ecf7b240df818ff2f6c0089c52c1ea418d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda2f38c0e470f9fd8c8b8b087c91ecf7b240df818ff2f6c0089c52c1ea418d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda2f38c0e470f9fd8c8b8b087c91ecf7b240df818ff2f6c0089c52c1ea418d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "05d61ab61f58db5ac579979fe49d205701de27036a68509eece4c9789f686383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be0bc1c3dcae3d476c7f86e6087c158cc9ea569f41d6b6bb185ce90e9b9214c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e97ef5d0bbf740880186aa812d008a05a0178329359870c6af1f69bf4cfd1782"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
