class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "ee96cafd254e50290ff64da80bf3240002cfc1d8d204defcfa7243e6fe86c47f"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b00ec365f5db144e8a09ca07667d6024905242832219fd64a7200b34fac6125c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc6106f1e65801808dd7f67ff7931284d94a67ec1e8c8d8ae8b3250650e1d163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ad410ce577fc199ffd0c2743c8fe0816ba2c55998dd8755d510c77ef2e501e"
    sha256 cellar: :any_skip_relocation, sonoma:        "400deb0a0094c4b8f1243ba87a1b15826e77318c1be8baffca37a3271b9c0205"
    sha256 cellar: :any,                 arm64_linux:   "40e55cf5da45ea8cbbfc461b501c68710954d7807b6ffd819a6d044e9bd4d480"
    sha256 cellar: :any,                 x86_64_linux:  "ecc93ce124a7a093922be8e87fc5989a9005e85c8cf3466ce9c8d56d7ea775df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig" => :test
    depends_on "libxcursor" => :test
    depends_on "xorg-server" => :test
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

    pids = []
    if OS.linux?
      # Not using xvfb-run which can leave behind processes running after test
      IO.pipe do |read_io, write_io|
        pids << spawn(Formula["xorg-server"].bin/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
      end
      ENV["FONTCONFIG_FILE"] = Formula["fontconfig"].etc/"fonts/fonts.conf"
    end

    ENV["INLYNE_LOG"] = "cosmic_text::font::system::std=trace,cosmic_text::shape=trace"
    ENV["NO_COLOR"] = "1"

    test_markdown = testpath/"test.md"
    test_markdown.write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN

    output_log = testpath/"output.log"
    pids << spawn(bin/"inlyne", test_markdown, [:out, :err] => output_log.to_s)
    sleep 5
    # macOS Intel CI runner fails with "Error: Failed to find an appropriate adapter"
    macos_intel_ci = OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match(/style: Italic.*\n.*'lorem'/, output_log.read) unless macos_intel_ci
  ensure
    pids&.reverse_each do |pid|
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
