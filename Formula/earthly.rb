class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.7.tar.gz"
  sha256 "f8e9e9afb466e9fe6525f867c8825eb1fa1c6614e60004dd88e1bd542cf6a8ff"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b955a47b38fa17490f5c8614c56faedb5e7c10194bd7c43d5a390bfe2936df5f" => :catalina
    sha256 "162bdc4555b29eff87162f351486dfc4694b287b552437e19f7632caadb79ba8" => :mojave
    sha256 "7a62ff3ac28ea63ed59b9f84947c20aa0b4b9b807b085f4877ff01726edba374" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=de7bfb10fcb6dc26b74aa2a76bc021773f8c9069 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "-o", bin/"earth",
        "./cmd/earth/main.go"
    (bash_completion/"earth").write `#{bin}/earth bootstrap --source bash`
    (zsh_completion/"_earth").write `#{bin}/earth bootstrap --source zsh`
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
