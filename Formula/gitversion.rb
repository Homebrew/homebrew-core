class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.3.7.tar.gz"
  sha256 "70c6f867e4a85325ba1e54211fd014d9b3ec9be43bb828393e1f0d6a5e33cefb"
  license "MIT"

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
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--author='Test <test@example.com>'", "--message='Test'"
    assert_match '"FullSemVer":"0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
