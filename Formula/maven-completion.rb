class MavenCompletion < Formula
  desc "Bash completion for Maven"
  homepage "https://github.com/juven/maven-bash-completion"
  url "https://github.com/juven/maven-bash-completion.git",
    :revision => "106b6ca03badc9474cf7b6b1b7039ad950a17f89"
  version "20160501"
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
