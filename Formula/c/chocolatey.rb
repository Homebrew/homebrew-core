class Chocolatey < Formula
  desc "Package manager for Windows, like Homebrew for Linux/macOS"
  homepage "https://chocolatey.org/"
  url "https://github.com/chocolatey/choco/releases/download/2.7.1/chocolatey.v2.7.1.tar.gz"
  sha256 "a3026526b9385813a66102a8df9fa18916c3b1ea291f2fd86af7439e61754fa5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "mono"

  def install
    libexec.install Dir["*"]
    (bin/"choco").write <<~SHELL
      #!/bin/sh
      exec mono "#{libexec}/choco.exe" "$@"
    SHELL
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/choco --version")
    assert_match "Chocolatey", shell_output("#{bin}/choco --help")
    assert_match "chocolatey - https://community.chocolatey.org", shell_output("#{bin}/choco source list")
  end
end
