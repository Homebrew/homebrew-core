class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://github.com/GitTools/GitVersion"
  url "https://github.com/GitTools/GitVersion/releases/download/v3.6.5/GitVersion_3.6.5.zip"
  sha256 "6f119c065a6bd9a3298a6d2a3cd97c83278d9031b5171f74d032eea38e090f13"

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
