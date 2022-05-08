class FabricCompletion < Formula
  desc "Bash completion for Fabric"
  homepage "https://github.com/n0740/fabric-completion"
  url "https://github.com/n0740/fabric-completion.git",
      revision: "5b5910492046e6335af0e88550176d2583d9a510"
  version "1"
  head "https://github.com/n0740/fabric-completion.git", branch: "master"

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a73318f4d2d5ef0a1b8f14dd72755ee37273b33e9df402bf0c2b9b825a53f6a"
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
