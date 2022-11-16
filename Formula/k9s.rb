class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.26.7",
      revision: "37569b8772eee3ae29c3a3a1eabb34f459f0b595"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3668afb32b405e15d11004c7a2a11434b0ea36cfe04be1a76ad8d7ff0250c4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80856aad2aae79b20b5d3adbdf5d7315e279a1825f7057425a4eca9fe9d9daf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5937b7f3885bb99fc4408cc089a0b9b996a7449b7f992c4817ac6d9b4d67bdc6"
    sha256 cellar: :any_skip_relocation, ventura:        "f5c72f754340b83084481461759eefaddddbf70b2ef861959c92d18d82fb4948"
    sha256 cellar: :any_skip_relocation, monterey:       "bf6715e4a599bb9d574ec0e0ac3772204ec985576dc616f89d12769af8b807cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9940c7d60e866786907badb5c5c8e8a6d33b5e17421e2bfd9a8ed4466e05bf26"
    sha256 cellar: :any_skip_relocation, catalina:       "1f6dd146c63051d4f32214ccf559685039a0ffef4795a804d9a952190ed33226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6e9b4e7007ffa1f7dd86de347897f7ab63df604ddd5d234cff99cbc214e63e"
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
