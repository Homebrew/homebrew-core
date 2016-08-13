class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://github.com/GitTools/GitVersion"
  url "https://www.nuget.org/api/v2/package/GitVersion.CommandLine/3.6.2"
  version "3.6.2"
  sha256 "db05ebacfb76ddca26180f0c70060fbb89800e434d3d55b524785d0da37dbac8"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install Dir["*"]
    (bin/"gitversion").write <<-EOS.undent
      #!/bin/sh
      exec "mono" "#{libexec}/tools/GitVersion.exe" "$@"
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
