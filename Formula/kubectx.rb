class Kubectx < Formula
  desc "Tool that can switch between kubectl contexts easily and create aliases"
  homepage "https://github.com/ahmetb/kubectx"
  url "https://github.com/ahmetb/kubectx/archive/v0.5.0.tar.gz"
  sha256 "c66b970adc856fddc3b618c7c2a66574e100ff14f8a9b90031422856f7deb59c"
  head "https://github.com/ahmetb/kubectx.git"

  bottle :unneeded

  option "with-short-names", "link as \"kctx\" and \"kns\" instead"

  depends_on "kubernetes-cli" => :recommended

  def install
    bin.install "kubectx" => build.with?("short-names") ? "kctx" : "kubectx"
    bin.install "kubens" => build.with?("short-names") ? "kns" : "kubens"

    bash_completion.install "completion/kubectx.bash" => "kubectx"
    bash_completion.install "completion/kubens.bash" => "kubens"
    zsh_completion.install "completion/kubectx.zsh" => "_kubectx"
    zsh_completion.install "completion/kubens.zsh" => "_kubens"
    fish_completion.install "completion/kubectx.fish"
    fish_completion.install "completion/kubens.fish"
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubectx -h 2>&1", 1)
    assert_match "USAGE:", shell_output("#{bin}/kubens -h 2>&1", 1)
  end
end
