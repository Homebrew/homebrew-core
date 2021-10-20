class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v1.3.0/Cake-bin-net461-v1.3.0.zip"
  sha256 "52934fec19c02b668851b73d0fac9f3e6676be239e5bfef6af54b56fb91a244c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07296553a62cd35f5c25ab24cd8a36179db132c965ed5c2afd30853aa2313e51"
  end

  depends_on arch: :x86_64 # mono is not yet supported on ARM
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
