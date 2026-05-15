class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "948cc9366f8191407eb5471ca6aa4a1f72408e7375fbc6df19927bac6ef955eb"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8033e5f3d3ebcf5925baa1ebac0d82f661f77fbf96bbdd6f39b8b040591add68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fb03f841c34c5807aa9073c53c2694db9069b5b8353aca8bc1fd4b82b6152f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f139d17acc3f16314388f17add45ce33569b3cf421e9218630fc71683578c350"
    sha256 cellar: :any_skip_relocation, sonoma:        "f79bd98c2dfca1fc55b66364ec319c2ffe7de00445caf0cedb5f7d63dfc7e16a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927b271f06b0d6c271e51b2b4ffb8162fa11cdd35df0ce40a27716195d91bf8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ceeceab37ebc14ab14475c456250d62cd6e9983bf7475d6a9f980d827bcea6"
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
