class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "7241a92414991211b5e58130bd4613c960d610f0255279ee5993654fd026e3cb"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbeb2fdf9bb810d7da7ed335d6fbe0ff27db8487936d7a5b825eeb5baa113da0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbeb2fdf9bb810d7da7ed335d6fbe0ff27db8487936d7a5b825eeb5baa113da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbeb2fdf9bb810d7da7ed335d6fbe0ff27db8487936d7a5b825eeb5baa113da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d6aa6c549aaa7d61906a904951882d640c170f0a5b4fbc0d79dcf457d1c9116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11ffdacc50d46489ea2fe13f6c7075c5b43915490d252f3b2e45d106950fbfaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c82f59f326eaf3887056e1ea1d5b4b04f5f7f575df6b49de9c3854c498fb1aad"
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
