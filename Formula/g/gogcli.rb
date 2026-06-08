class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "5484b6e3ea1be5d6cea0b664406726dfcd0ab2ef327e26587a46804497dc9480"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc3f375f647cf04219c0f2be0e5b2b7c74eabbab94bad6ec859abd1d14c2d52c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41758322e49c60bcfc67da741a8adb33baaea8be935fdd896b69c5c4e2c6b261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "992dfeb2ad55c5b54d39031ccd0d7ef99b1beeb58e17c95e1eccde10e7512d57"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a24d5b266d52e163436343fc973b55b2db239d5ab623bebd2786ffed6814817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c441d1dbbe356b900da34e7bf680f852484a029d976a5757193bb7b5dea95e"
    sha256 cellar: :any,                 x86_64_linux:  "d1c1f451a97ef3dbb3a0698e4b0629eb91fdc267dc1d2141e1b2dfa3a5e2dc4a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end
