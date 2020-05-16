class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.28.1.tar.gz"
  sha256 "dcba3a9e4e8f4956af46b797dae0a701f6043e879746b33cc744ea2a5542ae76"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "105f254bfdca41b245d460591535c51cd8bdd1ffa72ec699085541f91deb9e60" => :catalina
    sha256 "ebd7fabbe0844a821e50bc76ccf29bde7c6fffe14c1fc6fde7546d18d4828ac8" => :mojave
    sha256 "60c1ad2bb51a2576d4a9927754ab5fc290de56138eda881832aa501615d5e654" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
