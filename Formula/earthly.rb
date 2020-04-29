class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://docs.earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.1.1.tar.gz"
  sha256 "17ce130e957739da1b96245235aebb584a54241f69aea0802b97948172f5744e"
  head "https://github.com/earthly/earthly.git"

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
