class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.10.tar.gz"
  sha256 "5a4cdca526241f322e51fc307a5be2ef236281b6c5cca833fa04bc8eecd9f725"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "074500246f1d2126be337a7e4e7e3c2a67c7fdeba36c117762429498fa6b3402"
    sha256 cellar: :any, catalina: "f9fc949d7bd6936727afc88e1e5de5ef2ebf08bcf6ad623061500123c0b7cd3c"
    sha256 cellar: :any, mojave:   "ead216a29291d95b3b716ae0956811c71d7bac1dcfc90421a696c1236f92e585"
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
