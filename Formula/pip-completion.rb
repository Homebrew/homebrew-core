class PipCompletion < Formula
  desc "Bash completion for Pip"
  homepage "https://github.com/ekalinin/pip-bash-completion"
  url "https://github.com/ekalinin/pip-bash-completion.git",
    revision: "f5a7216a5620c3da5ae1d4a2c6ce9b64009b31c2"
  version "20190723"
  head "https://github.com/ekalinin/pip-bash-completion.git"

  # There currently aren't any versions of pip-completion and the formula
  # simply uses a revision from the upstream GitHub repo. The YYYYMMDD version
  # in the formula isn't from upstream and was created on our end to indicate
  # the date of the revision that's being used.
  livecheck do
    skip "No version information available"
  end

  bottle :unneeded

  def install
    bash_completion.install "pip"
  end

  test do
    assert_match "-F _pip",
      shell_output("source #{bash_completion}/pip && complete -p pip")
  end
end
