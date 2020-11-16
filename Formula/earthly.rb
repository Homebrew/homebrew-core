class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.14.tar.gz"
  sha256 "2fbabdb785aa0e98703720baf27b954b80a4f13bc1e7482dc461379d04583240"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "041036a064ff06c870890f5a98dcb190e1569f7238bff486d6835e34d784f518" => :big_sur
    sha256 "13e005de187c3e36c95908e374a31a48a8b28a98c0bf2586a435b1738b289698" => :catalina
    sha256 "938c63063d508278d789a6db56824416bf88fa75db6e20ae88701003c2ef5248" => :mojave
    sha256 "b917b59ba47a99a6ce73beb6e1ae01346d652662e6af50a1d41a59d875bf3f45" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=c87b61e44db352a2bd25379c432ebad7b835fc4a "
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
