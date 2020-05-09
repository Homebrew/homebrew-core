class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://docs.earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.1.2.tar.gz"
  sha256 "95e12e683d2de50a5d7f5ee3134146fcfdfe980c13055402d82b7fcb003e47a2"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1216bfa70f61b610cc891e0eecfd0f4eeaa07198717972be7aa373e5dd157611" => :catalina
    sha256 "b2ba9cdbedf9b576ad57ccd9626d38e64deac683450a48ee8356ec2fc73647b5" => :mojave
    sha256 "449c3fc3b698b7fa8d728ddd630f1b84382d2b84a060029f885f7441148c1b42" => :high_sierra
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
