class FabricCompletion < Formula
  desc "Bash completion for Fabric"
  homepage "https://github.com/n0740/fabric-completion"
  url "https://github.com/n0740/fabric-completion/archive/5b5910492046e6335af0e88550176d2583d9a510.tar.gz"
  version "1"
  sha256 "34db5a8b207a66170580fc5c9d7521e76f3c3ee85471fa19a27718dca9a934a7"
  license "MIT"
  head "https://github.com/n0740/fabric-completion.git", branch: "master"

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3d2a6d8ccfa6f87727fb8d7530c7a4fb20fda11dd0a580740bb7a4179b0e54c0"
  end

  def install
    bash_completion.install "fabric-completion.bash" => "fabric"
  end

  def caveats
    <<~EOS
      All available tasks are cached in special file to speed up the response.
      Therefore, Add .fab_tasks~ to your ".gitignore".

      For more details and configuration refer to the home page.
    EOS
  end

  test do
    assert_match "-F __fab_completion",
      shell_output("bash -c 'source #{bash_completion}/fabric && complete -p fab'")
  end
end
