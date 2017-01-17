class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/1.0.5.tar.gz"
  sha256 "772860ce11142354e48292691d0fc392618df7bb8336a6ea3d926eaba4615189"

  bottle :unneeded

  def install
    bin.install "gibo"
    bash_completion.install "gibo-completion.bash"
    zsh_completion.install "gibo-completion.zsh" => "_gibo"
  end
end
