class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "60f111e67d8e0b2bbb014900d4bc84ce6d2823c8daaba2d7eda0d403b01d7d1b"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838ef3d45e6949f7a57bfd46aec5183010b77f197d6b1512e25f449cf9f6cd00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdec9ff919ff61a2915e6e82d19c6e9e74b40b2b052b826855fcd5362adc9b79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68fbf10b131d5b4a03c3dac634cab8201920c409586b37f18478aecbde5bd561"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b2b521422c8576337f04820780d2b07aabcf89afb0c6a03da7c9dfdf4efb9aa"
    sha256 cellar: :any_skip_relocation, ventura:       "6007d217d4843db5e2e32ee15f00e0b76c31b9b5f788bec283d47f9e0020e48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "756fd700b1045273f04784edcce040a85e14a12cd01a0033d4dcbc119f660bdf"
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
