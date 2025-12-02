class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0473d154469c4f078029c2fdb58dca19b8d415633934773c41930536b54e71e0"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b032f9a33f0c8c3c9a1ca03cb6cf0453740b45756ffb0843eba0676f69b71426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08618c2b26c159f199bb3b0ec92f989d0cc101f615288f1eec2a587f60fb0622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93ba8afea50e4112475f7d41b4a4a952b242f48e6791550dcf4459430b0c6d70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce4fafe2f79643c467a358a1ad72309be4f791eade01de70dfb7e91d4ef41298"
    sha256 cellar: :any_skip_relocation, sonoma:        "420ff2e57ec6742be5eb6074b489dd8a04a5811a471ba3448ddfedf821447de8"
    sha256 cellar: :any_skip_relocation, ventura:       "34aee2a7ddd8c4b85a2f4187a0d380f69a9830ef00e2c57d3165f7e55319056c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2a1671d0354386d01527ce7fceb5d00eebbe9ed629760c8a4aff044b38be002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1df3c19155248403249b2d8f39a1633c058142eaa20c9023925a21d18d5c48"
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
