class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.10.tar.gz"
  sha256 "5a4cdca526241f322e51fc307a5be2ef236281b6c5cca833fa04bc8eecd9f725"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "5e99b09d02ac3aa3074a179782ad8fcca9ca6c93a9188d83e5f6e1a05abbb985"
    sha256 cellar: :any, catalina: "f241568286448f027878bd1f1adf1900377d6b064651a19b4632c65f295f7046"
    sha256 cellar: :any, mojave:   "e0bb3d487d3960d9aabcd20f8a305759d5d03afb95e3e8e0e4e78c21730fd204"
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
