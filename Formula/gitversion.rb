class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://github.com/GitTools/GitVersion"
  url "https://github.com/GitTools/GitVersion/releases/download/5.0.1/GitVersion-bin-fullfx-v5.0.1.zip"
  sha256 "9b543d3e42e0d5e6fab0b44553cb6bbbb0e31431030ef761fc1a50c845fd166a"

  bottle :unneeded

  depends_on "mono"

  uses_from_macos "icu4c"

  def install
    libexec.install Dir["*"]
    (bin/"gitversion").write <<~EOS
      #!/bin/sh
      exec "#{Formula["mono"].opt_bin}/mono" "#{libexec}/GitVersion.exe" "$@"
    EOS
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["JENKINS_URL"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--author='Test <test@example.com>'", "--message='Test'"
    assert_match '"FullSemVer":"0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
