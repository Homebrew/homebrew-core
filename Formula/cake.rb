class Cake < Formula
  desc "Cross platform build automation system with a C# DSL."
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.23.0/Cake-bin-net461-v0.23.0.zip"
  sha256 "1ad334de4188e6dd320a8501dd0d76f5efc8f2f4e83a562fb3f309a298f39a4a"

  bottle :unneeded

  depends_on "mono" => :recommended

  conflicts_with "coffeescript", :because => "both install `cake` binaries"

  def install
    libexec.install Dir["*.dll"]
    libexec.install Dir["*.exe"]
    libexec.install Dir["*.xml"]

    bin.mkpath
    (bin/"cake").write <<~EOS
      #!/bin/bash
      mono #{libexec}/Cake.exe "$@"
    EOS
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
