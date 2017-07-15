class Cake < Formula
  desc "Cross platform build automation system with a C# DSL."
  homepage "http://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.21.1/Cake-bin-net45-v0.21.1.zip"
  sha256 "a5d28df7ac33cf0111a33d04118a6f1f0fd91675d721db8ea5f94665818aa883"

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
