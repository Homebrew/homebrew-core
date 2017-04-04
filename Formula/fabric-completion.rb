class FabricCompletion < Formula
  desc "Bash completion for Fabric"
  homepage "https://github.com/kbakulin/fabric-completion"
  url "https://github.com/kbakulin/fabric-completion.git",
    :revision => "5b5910492046e6335af0e88550176d2583d9a510"
  version "1"
  head "https://github.com/kbakulin/fabric-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "fabric-completion.bash" => "fabric"
  end

  def caveats; <<-EOS.undent
      All available tasks are cached in special file to speed up the response.
      Therefore, Add .fab_tasks~ to your ".gitignore".

      For more details and configuration refer to the home page.
    EOS
  end

  test do
    assert_match "-F __fab_completion",
      shell_output("source #{bash_completion}/fabric && complete -p fab")
  end
end
