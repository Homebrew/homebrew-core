class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.9",
      revision: "ffdc7b70f044e1f26c2f6fbb93b5495e4ebdb1ad"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c86b4a8a8e57ee0637cccb45e9ec2c4615db3b9a132e72a79800e8f015f0b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c09b21891002fbefb699f8418d77bdb49a5e1ea3a991e1c0f604bd5fab3a27f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f058726009af36e7db23dbd7a007e5c544df6edbe5eb16e5bb99be9693a1bb72"
    sha256 cellar: :any_skip_relocation, sonoma:        "b82aa88e05bedee1d0f017d18b149907636a676e8f3ebe44fb037ac953fa16f5"
    sha256 cellar: :any_skip_relocation, ventura:       "1e46aa2f0549bbc12d028cd4ac1fbd340538709bf3cbd11d21b1f3fb58dd9876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71367c264a832bcda28f026198319d638b5ffff5fb0fbec7d4d12f0a4b1c2618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b682f2ece6e37f7771be0a650da01299ebec51ff162d23babfdfb2c3923cd48c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
