class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "4a2f426e88cf192f6aad1bd927640b97350bf6447620d7252bf0d6d01d6d3f40"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c71558219e2155f46b8368e86a2c94d2cfcb1343a6c778206352f756b1132979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172410bd8d667ac189b83239ae9a69416841149ccf7c342fd48f465624da5736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ae3b7cc6bd72e08fd3136afbbc206c765f342e9e0cfa6d8b781b4b6b94d297"
    sha256 cellar: :any_skip_relocation, sonoma:        "022ee6bf5416aa56b541a523e22f6a05c5e2c33b9e22cb75479010abc5f46545"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f893fe36cef927e593c9bc6a64e5fbe926c8e784c3332225fc9203bb8c38c999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db12f52dd1c64cd4578f9474b5f36d4869fd2ffd57c0521fb252e4c895c1b8b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "libxkbcommon"
    depends_on "wayland"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/inlyne.bash" => "inlyne"
    fish_completion.install "completions/inlyne.fish"
    zsh_completion.install "completions/_inlyne"
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
