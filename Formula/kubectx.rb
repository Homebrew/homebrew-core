class Kubectx < Formula
  desc "Tool that can switch between kubectl contexts easily and create aliases"
  homepage "https://github.com/ahmetb/kubectx"
  url "https://github.com/ahmetb/kubectx/archive/v0.9.4.tar.gz"
  sha256 "91e6b2e0501bc581f006322d621adad928ea3bd3d8df6612334804b93efd258c"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56fca18baee3ff65f4e6ca1491b515f46bcb61c3d184bc68c77c1b06e2e32cfb"
  end

  depends_on "kubernetes-cli"

  def install
    bin.install "kubectx", "kubens"

    bash_completion.install "completion/kubectx.bash" => "kubectx"
    bash_completion.install "completion/kubens.bash" => "kubens"
    zsh_completion.install "completion/kubectx.zsh" => "_kubectx"
    zsh_completion.install "completion/kubens.zsh" => "_kubens"
    fish_completion.install "completion/kubectx.fish"
    fish_completion.install "completion/kubens.fish"
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubectx -h 2>&1")
    assert_match "USAGE:", shell_output("#{bin}/kubens -h 2>&1")
  end
end
