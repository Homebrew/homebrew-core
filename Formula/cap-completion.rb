class CapCompletion < Formula
  desc "Bash completion for Capistrano"
  homepage "https://github.com/bashaus/capistrano-autocomplete"
  url "https://github.com/bashaus/capistrano-autocomplete/archive/v1.0.0.tar.gz"
  sha256 "66a94420be44d82ff18f366778e05decde3f16ad05d35fd8ec7b51860b102c0c"

  bottle :unneeded

  def install
    bash_completion.install "cap"
  end

  test do
    assert_match "-F _cap",
      shell_output("source #{bash_completion}/cap && complete -p cap")
  end
end
