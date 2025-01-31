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

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "fontconfig" # for fontsdb
    depends_on "libxcursor" # for winit on X11
    depends_on "libxkbcommon"
    depends_on "wayland"
  end

  def install
    system "cargo", "install", *std_cargo_args
    bin.env_script_all_files libexec/"bin", FONTCONFIG_FILE: etc/"fonts/fonts.conf" if OS.linux?

    bash_completion.install "completions/inlyne.bash" => "inlyne"
    fish_completion.install "completions/inlyne.fish"
    zsh_completion.install "completions/_inlyne"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inlyne --version")

    test_markdown = testpath/"test.md"
    test_markdown.write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN

    ENV["INLYNE_LOG"] = "info,inlyne=debug,cosmic_text=trace"
    ENV["NO_COLOR"] = "1"
    ENV["TMPDIR"] = testpath

    if OS.linux?
      xvfb_pid = spawn Formula["xorg-server"].bin/"Xvfb", ":1", "-nolisten", "unix"
      ENV["DISPLAY"] = ":1"
      ENV["LC_ALL"] = "en_US.UTF-8"
      ENV["XDG_RUNTIME_DIR"] = testpath
      sleep 5
    end

    Open3.popen2e(bin/"inlyne", test_markdown) do |_stdin, stdout_and_stderr, wait_thread|
      sleep 10
      if wait_thread.alive?
        Process.kill "TERM", wait_thread.pid
        output = stdout_and_stderr.read
        assert_match "Line LTR: 'lorem ipsum dolor sit amet'", output
        assert_match(/style: Italic,.*\n.*Run \[\]: 'lorem'/, output)
        refute_match "ERROR", output
      elsif OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]
        # Ignore Intel macOS CI as unable to use Metal backend
      else
        # Output logs and crash report to help determine failure
        message = "No running `inlyne` process. Logs:\n#{stdout_and_stderr.read}"
        if (report = testpath.glob("report-*.toml").first)
          message += "\nCrash Report:\n#{report.read}"
        end
        raise message
      end
    end
  ensure
    Process.kill "TERM", xvfb_pid if xvfb_pid
  end
end
