class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.19.tar.gz"
  sha256 "4ab1b3cba1e59717ea16a6a5f4882e9ab7987b5a10b97aeb0c15795de63ad98d"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e365fedf49ff5351721b50964c3bedc4f0af85e35fd6f51441c630fb181be14" => :big_sur
    sha256 "a5733afdac9f70e363a751fdac5c05f315b32bd97d1aa6c5af61e30fba6172a3" => :catalina
    sha256 "227fa9dd9d84499b3b4a5f164b2aed99f30a3fb9b2a9701c004a7d18a90430e8" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=15320ce66408df05cfa6918a5ad69bd4d5b4cb0f "
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
