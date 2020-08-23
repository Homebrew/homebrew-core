class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.1.tar.gz"
  sha256 "b0730ed12ab6f0c15cdf27980f5982009fa62e0631cdede021ef5fd9c81a051c"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da9d4f4c382ea6380c4c5ee82f9b7b42efd9be7f6e7c019eea5bfd97f7a63479" => :catalina
    sha256 "709ec0a0a31a4b0c10f571bc384fe3c75b49ca50d19eba28061156307746bbd0" => :mojave
    sha256 "ca13dba89290ac229a849a4c3f6acb6f598e69471260893fddd9e32dae89aeb5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
        "-tags", "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork",
        "-ldflags",
        "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version}",
        *std_go_args,
        "-o", bin/"earth",
        "./cmd/earth/main.go"
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
