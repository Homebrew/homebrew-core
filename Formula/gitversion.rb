class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://github.com/GitTools/GitVersion"
  url "https://github.com/GitTools/GitVersion/releases/download/v3.6.4/GitVersion_3.6.4.zip"
  sha256 "e2cea2d3949a5128e5b924d1f65bd09eebc71e019932f9e2632eb11fe7c0b643"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install Dir["*"]
    (bin/"gitversion").write <<-EOS.undent
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
