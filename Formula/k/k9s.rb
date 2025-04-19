class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.4",
      revision: "e4e38161857a202f09488c7ab3603a27de464ad4"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0739ca6c271a92aae6622d205988336272f8af240d95bdb415c20ffdc708ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "313b9c82ba8259472fe083c294231585d2db52c462fd0a4db721af0bdf2ebc0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c28150787b904c5e62e66db83f648568b0a8b39f53cae89b50f82ad3012fe1f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b0eb48cd15f1c310745d73b57962cedf912717ede640aec76c34900a8207c09"
    sha256 cellar: :any_skip_relocation, ventura:       "6290703a99dfe54b49d459d90e0d5a17e383d8ce27f0a26d7090ae384d9baaa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d66b720b77b225cdd63112d8aec88f28be62f8a20ca01a32336a18b563662ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34764568ecc4d8351b7fb744f9f5748475caac67f1c19cc53087c600121b265d"
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
