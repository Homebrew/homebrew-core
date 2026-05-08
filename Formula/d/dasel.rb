class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "92711ddecfad9a1e97a41011d12ea88e9bb3c37827e5d5a718c3a8e8eaa88eaa"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7c6b8f1fc5d5c414ce057e3cbb762ffb9d73d8f9bf441af9327d84bcb45a6be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c6b8f1fc5d5c414ce057e3cbb762ffb9d73d8f9bf441af9327d84bcb45a6be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c6b8f1fc5d5c414ce057e3cbb762ffb9d73d8f9bf441af9327d84bcb45a6be"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a4d09ad9355e94e78b4be35b660320fa4aa0a18e1abfbc6763fc938dddf27ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5865f7bff058b28d1a188e37fd2efafcf77b5d4dea4839ae915ce02df6bdb5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c5c7b828d9504bdeccfd0f80ca3c1465eb49cb9e1b064f24b8965056db27d06"
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
