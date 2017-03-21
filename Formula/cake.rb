class Cake < Formula
  desc "Cross platform build automation system with a C# DSL."
  homepage "http://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.18.0/Cake-bin-net45-v0.18.0.zip"
  sha256 "bf55f7b3f8b4780032719055133265c5ee9d6385df0638930817825af3367647"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install Dir["*.dll"]
    libexec.install Dir["*.exe"]
    libexec.install Dir["*.xml"]

    bin.mkpath
    (bin/"cake").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/Cake.exe "$@"
    EOS
  end

  test do
    (testpath/"build.cake").write <<-EOS.undent
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
