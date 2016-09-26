class Launch < Formula
  desc "Command-line launcher for OS X, in the spirit of `open`"
  homepage "https://sabi.net/nriley/software/#launch"
  url "https://sabi.net/nriley/software/launch-1.2.3.tar.gz"
  sha256 "b4bedaa61f7138f9167e7313e077ffbfc0716a60d4937f94aaedf3f46406bc38"
  head "https://github.com/nriley/launch.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "f46796abd639e0bb58b97a8c03c598733ead23768799389c70182e2ebde3d70e" => :el_capitan
    sha256 "dd1295732ee8c5642a70005e5139f606d11f3677b7542a8b772fd164b25551e1" => :yosemite
    sha256 "66516ede076656bf3603fb80b499965f7a8715eead23d56ff38de33077bf816b" => :mavericks
  end

  depends_on :xcode => :build

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    xcodebuild "-configuration", "Deployment", "SYMROOT=build", "clean"
    xcodebuild "-configuration", "Deployment", "SYMROOT=build"

    man1.install gzip("launch.1")
    bin.install "build/Deployment/launch"
  end

  test do
    assert_equal "/", shell_output("#{bin}/launch -n /").chomp
  end
end
