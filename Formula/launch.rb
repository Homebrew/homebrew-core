class Launch < Formula
  desc "Command-line launcher for macOS, in the spirit of `open`"
  homepage "https://sabi.net/nriley/software/#launch"
  url "https://sabi.net/nriley/software/launch-1.2.5.tar.gz"
  sha256 "486632b11bee04d9f6bcb595fd2a68b5fde2f748ebdc182274778cc5cf97ff70"
  head "https://github.com/nriley/launch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39473462b7b66e86f4d3abfef40f6b9314793ae6d621dba3ca61ccf9f06f1d0f" => :mojave
    sha256 "7ea743ebff2392770ebb7bd7ff0a420ad9a3f6bc50d1181df7518a5fe46a8000" => :high_sierra
    sha256 "4fa06c0d934752695a0c823c51569063b50f8826c7fb9cbd302f731b059e4225" => :sierra
    sha256 "9905b0dd99460cd88d48a1cf4c230ec03db380262001fa7a2ba54cbcbb84fad0" => :el_capitan
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
