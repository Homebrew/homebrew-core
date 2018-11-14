class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://github.com/GitTools/GitVersion"
  url "https://github.com/GitTools/GitVersion/releases/download/v4.0.0/GitVersion-bin-net40-v4.0.0.zip"
  sha256 "872c6cfaecd8693a37c3d3fcb77c24bf4068ea5db14fee4dad9912a6b922b9f1"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install Dir["*"]
    (bin/"gitversion").write <<~EOS
      #!/bin/sh
      exec "mono" "#{libexec}/GitVersion.exe" "$@"
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
