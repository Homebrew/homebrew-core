class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.11.tar.gz"
  sha256 "f0e913bb577a38e9d455a36834f4627e9d9a3b5892d089d8d360950fa2e66d3f"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56200f59b6dc71a6957511521188d757d31f4c8d64d7d6332a6e0cd927862168" => :catalina
    sha256 "1a3caa655f68c3164ab26e28c3690ce0255d1b72a73b8673d7f0bbb5519ffa16" => :mojave
    sha256 "117fa362e785b41994374d2c880467d31389da9d12bf0bb70754bca60fbca6b9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=9f063bb67c60553bffca47861be33534874d3e47 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "-o", bin/"earth",
        "./cmd/earth/main.go"
    bash_output = Utils.safe_popen_read("#{bin}/earth", "bootstrap", "--source", "bash")
    (bash_completion/"earth").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earth", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earth").write zsh_output
  end

  test do
    (testpath/"build.earth").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earth --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
