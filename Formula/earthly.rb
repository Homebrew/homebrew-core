class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://docs.earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.1.3.tar.gz"
  sha256 "bfbfddc52eb39dd6ea389dc5c8a86386e72005ea17d04af6b36ca5400492e328"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ca58275640a516761e0504c6dcc6cb54d95c2021cc5854c62e8fad8b913162a" => :catalina
    sha256 "710d53105dfc73c87644b78b3774c28527fbcd7a7d318d5570a535deb4e8453c" => :mojave
    sha256 "ce55de852ba83929418132d164782201a5d2de319ee5b3b04392f2e6ec401fc6" => :high_sierra
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
