class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://docs.earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.1.3.tar.gz"
  sha256 "bfbfddc52eb39dd6ea389dc5c8a86386e72005ea17d04af6b36ca5400492e328"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9d081a7be9262da6dc7bfe6ae12aa5fc205c561ac7f0100ee4e755d825cb0cd" => :catalina
    sha256 "5691c82dda25a670ed259f5c62fba0e80f487e30c70bd5e16c05849c059cd714" => :mojave
    sha256 "b64b1bc3b5bd01cc2c95c6993afda7bd3077733437ee9c9376c18686090c65f3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
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
