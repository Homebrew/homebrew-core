class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.5.1.tar.gz"
  sha256 "915e6eed296652072c0060a79ff8d665c348cc3e386d969fd45a1df615609777"
  license "MIT"

  bottle do
    cellar :any
    sha256 "aafbdba40a99693085eb43b73c1901ec25c5ce60f87bfe195becbb88ab70d907" => :catalina
    sha256 "cd9169e8c0a4624f0cfb9c1c919d864726cad064856ba7c53da6e7e49fc7253a" => :mojave
    sha256 "6fa6fbe0eb6dd8a7d226e655199321ffca584d78ab85fcb9c29ee9b1499076eb" => :high_sierra
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "netcoreapp3.1",
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
    assert_match '"FullSemVer":"0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
