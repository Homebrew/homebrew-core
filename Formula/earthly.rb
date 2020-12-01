class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.16.tar.gz"
  sha256 "3950985308acacd20abb81403d7de9a4d3fa99ff36ec48f6f6cbbba33b1a6291"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8eee13ef74f53d9a4463f1ae90d6fb3eaf5475bb5d17d2c7f6e8a85c62466f82" => :big_sur
    sha256 "d5db79ea4d4d466e0fc952da047bf377ea62daa06ee1ec228f2cdff4c3b2e58b" => :catalina
    sha256 "d527e537a97b980e88bf6bd8c2e871cf1b8600b0df9991b673ef33327921a0c6" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=0dd480b951ce169382bad95b9c1d50cfbe36ed12 "
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
