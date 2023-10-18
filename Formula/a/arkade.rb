class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.13",
      revision: "9c9b29c1e97c4a893a652e2c594a84e8001e6885"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "397c0644621cae4993f87b732e74f98961e7f587af919096f2dc8d98ccbc8eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d35b6066d7159e6311c9ecb7f9426c1e9d80d4c5691da727a1febb39335a9a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7533aeeffef84311759d731455450bde896c42ccc501bd6afa4812ad2db1f54"
    sha256 cellar: :any_skip_relocation, sonoma:         "77d716c6b79882987bafe03df4b9f7861c2a3a8461ffbced0976b6832524bd63"
    sha256 cellar: :any_skip_relocation, ventura:        "1fec81cc5815384876630f897db45ee344ed0924f1a6e29796a3a1bc79f84ad3"
    sha256 cellar: :any_skip_relocation, monterey:       "2c6992175d8b26c21e0c179a50ed78f8e8bca971b2005f5b98fec56bf6b46a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b1c1a8fb2d34e3e5a925e2a54f4546091080836c087648eb9812b46701da335"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
