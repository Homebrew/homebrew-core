class Cake < Formula
  # As discussed with chenrui333 in this PR: https://github.com/Homebrew/homebrew-core/pull/55500#issuecomment-636390974
  # Cake uses the pre-release setting on all releases.  This will change
  # once we ship version 1.0.0, which is likely going to be our next release.
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v1.1.0/Cake-bin-net461-v1.1.0.zip"
  sha256 "e556aaf3675728ce349569bd19b32492c36a9d9ad97acf3e1e007bab8f6eddfa"
  license "MIT"

  bottle :unneeded

  depends_on "mono"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

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
