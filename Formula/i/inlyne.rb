class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "60f111e67d8e0b2bbb014900d4bc84ce6d2823c8daaba2d7eda0d403b01d7d1b"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f10df680898a5e7eeee773c88f0776b9aadd67ab4528f1f7b85e6245989d4cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "058ba9fb4ef89574c9cbfc209e2aceee23a410035be89151a62cd0aa533083d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bf23f146cd3bb60b43c825a343c59ed9be6923e94148fa5f740d5942677f41c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6925e3bc0b8b2acca938a7f51f878023b31608cdeddea578370bfb55b033baf4"
    sha256 cellar: :any_skip_relocation, ventura:       "f686de15fe9dd4840053323e489b69dba92215d6b67f494b7dbbfe4ac26658e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330b0c5da919d5226afdbbaf7d3b4ced74443cce34970e00fb4d029dda7e9968"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "libxkbcommon"
    depends_on "wayland"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inlyne --version")

    # Fails in Linux CI with
    # "Failed to initialize any backend! Wayland status: XdgRuntimeDirNotSet X11 status: XOpenDisplayFailed"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    test_markdown = testpath/"test.md"
    test_markdown.write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS

    script = (testpath/"test.exp")
    script.write <<~EOS
      #!/usr/bin/env expect -f
      set timeout 2

      spawn #{bin}/inlyne #{test_markdown}

      send -- "q\r"

      expect eof
    EOS

    system "expect", "-f", "test.exp"
  end
end
