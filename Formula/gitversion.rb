class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.9.tar.gz"
  sha256 "9e828352dead4da1c6a6ba148395b8b19a92e96a00c28abf94004ea8f7249577"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "4ef6fd456a2c587322029a847dd8bc815b0aa974ecf72681609277a371ed50e2"
    sha256 cellar: :any, catalina: "5b990fde7269e949371e2dadc7b29ad75821e71ecc67191f68521234b4db007a"
    sha256 cellar: :any, mojave:   "aaa165ebb2c47fe3cadd2c051674d9dbb9b304e8e17c0165a02af4e6721d14c5"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "src/GitVersion.App/GitVersion.App.csproj"

    libexec.install Dir["out/*"]

    (bin/"gitversion").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/gitversion.dll" "$@"
    EOS
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
