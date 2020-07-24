class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.2.1.tar.gz"
  sha256 "1b3216d7b1b2acf3f923ef37dbadde56f917b822cdb10c505fdda41bd7b47b97"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c371ff89ccf8140b47bc84e766862c367da681862de108dbd1b348f225d5b3ff" => :catalina
    sha256 "16b5702d20a00ebc23fd295fe6037e8fac991cfff567ed9e939c86bea0d85c3e" => :mojave
    sha256 "b73029dfe295bed6c1925d6ccef879211d5107d5faff41a953a05a937906db12" => :high_sierra
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
