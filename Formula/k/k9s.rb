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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e2c7bb4ec8796e1e3decf5ccc290ccd9157afab74ecdbb9b364c6b09a8d4c27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71bdebb63c3572b272c185594fa92cbb0ed874660298b408e40bbdd9a98a028f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0852ef462d130b1b850ef4ffd58883c3238cf17b7128523cc120d35f1b2cb929"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f0f3c913aed0b1978613f1e29f8f9c7c5d1aa7b91ac1cf4eb1c0ff6a2cd54d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a544e23740a9d44919c2c179535afd30a85f584459a9dbae8e7eeebf3e34f3"
    sha256 cellar: :any_skip_relocation, ventura:       "1af57909e267eb34f0a37d042ae754d1235cc7e318e5ed82a413536a3a354b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "049a08641a44964241275d0ed1d89c29aea8ce20bd8ee357fa354d9e42da73d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df2f8bfd4a30d5a888edb7b5a8c61d3f0dcfad8a53ab57ed4ab24785007c6c16"
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
