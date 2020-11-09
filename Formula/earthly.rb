class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.13.tar.gz"
  sha256 "348c384b100a406b3bec02fcb17a17ecfce8a33eee826e8333736642f25bf227"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98fea39beb7436e000e2ca20fbd63028ffdf352acfdb90511b6f2b2f36a59d72" => :catalina
    sha256 "aa4e1ba76ce35e95c4968a069fb08827ae91e640c1015ac1dc443ee7d53f9a04" => :mojave
    sha256 "c3d16b03589fdb0fa0d76fae5f78239aea8755d20bb7fbfdb3263c2aa0cfc022" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=6cd8e6ecc23b6b742bd1d7429fefb5c2662ab70a "
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
