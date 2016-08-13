class Cake < Formula
  desc "'C# Make' is a build automation system with a C# DSL."
  homepage "http://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.15.2/Cake-bin-v0.15.2.zip"
  sha256 "eb14a9c5e3b60e7bb10c980df7643dcd59c4cee5c3604601841380800d39930e"

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
    test_str = "Hello Homebrew"
    (testpath/"build.cake").write <<-EOS.undent

      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");

    EOS

    assert_match test_str, shell_output("#{bin}/cake ./build.cake").strip
  end
end
