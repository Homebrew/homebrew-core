class MavenCompletion < Formula
  desc "Bash completion for Maven"
  homepage "https://github.com/juven/maven-bash-completion"
  url "https://github.com/juven/maven-bash-completion/archive/20200420.tar.gz"
  sha256 "eb4ef412d140e19e7d3ce23adb7f8fcce566f44388cfdc8c1e766a3c4b183d3d"
  head "https://github.com/juven/maven-bash-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "bash_completion.bash" => "maven"
  end

  test do
    assert_match "-F _mvn",
      shell_output("source #{bash_completion}/maven && complete -p mvn")
  end
end
