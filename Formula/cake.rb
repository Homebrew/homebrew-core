class Cake < Formula
  desc "Cross platform build automation system with a C# DSL."
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.22.2/Cake-bin-net461-v0.22.2.zip"
  sha256 "4ff168eaa7e79af48dd02991149563560a6c8d41b3f5daa4527685bd54d51ea2"

  bottle :unneeded

  depends_on "mono" => :recommended

  conflicts_with "coffeescript", :because => "both install `cake` binaries"

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
