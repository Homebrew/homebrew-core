class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.4.tar.gz"
  sha256 "c84f8ce2991b7963f1666a2f836b8adf7c5ab368f1623a9c2e901e559f9218a6"
  license "MIT"

  bottle do
    cellar :any
    sha256 "8d85c8dcca7b5ea17b655558d64e0bb3d87c011403feb37dc48fd9be7ce4de93" => :big_sur
    sha256 "badc233636cd445698802092daca591f30cf51c2bd78f1d5d0fed0b1fee45f70" => :catalina
    sha256 "e1c08db8fbfdc8ad6c4d6826e78b246260ab6b06266ea9f85b8747c5efbb9e2f" => :mojave
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "src/GitVersionExe/GitVersionExe.csproj"

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
