class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.4.tar.gz"
  sha256 "c84f8ce2991b7963f1666a2f836b8adf7c5ab368f1623a9c2e901e559f9218a6"
  license "MIT"

  bottle do
    cellar :any
    sha256 "cb6164f3b238ed42388693615168e0fea56d945166da0912d9f7a3264df4b3ac" => :big_sur
    sha256 "29858e20f50cea39a42f8314357945d05e558ca7166324a2e7e608ce069727a4" => :catalina
    sha256 "0c0ebeeb392a191a18807997f9cd811fb96f3433fd65b595ccd324621c88dd2b" => :mojave
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
