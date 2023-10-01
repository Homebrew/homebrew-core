class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.27.4",
      revision: "f4543e9bd2f9e2db922d12ba23363f6f7db38f9c"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3594b27fde50a1d15a297d8fd82f7df3c3e079d8da1687379b5b7413081c76ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f0eab634ccffd0520bc096b29b0f2e4e41cd838b7dc54bc446ab87f96098b0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a06cdc10cc636b46e35e7729a1fb35f722a8f51c787c3cef3aef7b03efad8e24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a97c1a861bc020d523e9c606bc77c15e9cc2e71334245f3da4edf12f8b086d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6fa96dee9728e746350fe5d7d50cf1989d961481ac57469ba19c8aad47e6355"
    sha256 cellar: :any_skip_relocation, ventura:        "849252858d85f8f99ba5d930435dea66e2634f5facf6e30760f7fddf18dcca1b"
    sha256 cellar: :any_skip_relocation, monterey:       "0d79e1232b503f977436a4c7970859204de4cfedac06cfa96294bac3a6d0865a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ad0af28e4e9131245477728550b17001ef6e863bb6d11f5705407b8faf44047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440dafe23e099a97defb31ca8b7535c0afeda6f8b44979f888b8ac6ba438324c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
