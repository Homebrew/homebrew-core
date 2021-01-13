class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.4.5.tar.gz"
  sha256 "eacec637d26e91b50dd4573e735a179bbe1c9f049d3add413651e1a69ca834e3"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "935725b37ab822ffb7da9d432abe1652edede3715af0d21732f462cc34ebcb2d" => :big_sur
    sha256 "594495030b165903fb2f4acbd8712e9eb3f5c41d425206730d38ee136cd6ca1b" => :arm64_big_sur
    sha256 "4a36e325c5c8a46d7e0608d4734d13067e32be5e73bf2ab5844a1f4622067a67" => :catalina
    sha256 "6973f902f64db84575a0b4265288e94e72a95676e39f1b24bfab7ceba9adb6e0" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} -X" \
              " main.GitSha=69b9d5e26ddcbef167acfbda4293561cdd67449a "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "./cmd/earthly/main.go"

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
  end

  test do
    (testpath/"build.earthly").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earthly --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
