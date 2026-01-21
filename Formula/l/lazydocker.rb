class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker/archive/refs/tags/v0.24.4.tar.gz"
  sha256 "f8299de3c1a86b81ff70e2ae46859fc83f2b69e324ec5a16dd599e8c49fb4451"
  license "MIT"
  head "https://github.com/jesseduffield/lazydocker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5b2f48d5e3b87b3753bec5100423bd411152bc6564a32b902810c49099ba9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd5b2f48d5e3b87b3753bec5100423bd411152bc6564a32b902810c49099ba9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd5b2f48d5e3b87b3753bec5100423bd411152bc6564a32b902810c49099ba9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "88bc342ffdb7f32685c5c6009ef0c500de23c96d1dab4f9c4e20004c160a9e14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df5a1e13a64a3c1fe70f2d00fc5bf84ac7456f5ab4ed7811de8faab1f668d135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef65d57f4aa7bf4f18d73b3d905fc8c611a1f956370371fda388f7a6fe4474bb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
