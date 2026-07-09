class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "dcedc83369ea904b7148bd66b573ccc1cd27fe38ebd29bfde5299fd635704be2"
  license "AGPL-3.0-or-later"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a50c06d57fd102cc8b8a85123116efed4b87b1fe1e20e45b4aac952760f9def"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422dd056907cb0aebd8919e5a108e5ef4a48855c7036bf5b5aa0f36a4caaf857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "463c1023497e4431c3d1f2e799a088f11bb4e05773ae64ec4f85ffc8ac3fa1dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b68bd3b695bf1b6337b033884f3accd59f31915b0afc5ea3611c299e16497a"
    sha256 cellar: :any,                 arm64_linux:   "b9ac2093b7ce601bdb0f4a801365fa82561eb2e0b32fedf6e9b636aa5d43f574"
    sha256 cellar: :any,                 x86_64_linux:  "8e38d54e70a7093759f1e513238cd955573e0d503db4818f9c5765cd30c0267b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["HOME"] = testpath

    pid = if OS.mac?
      spawn bin/"bookokrat"
    else
      require "pty"
      PTY.spawn(bin/"bookokrat").last
    end

    sleep 2

    log_prefix = if OS.mac?
      testpath/"Library/Caches/bookokrat"
    else
      testpath/".local/state/bookokrat"
    end

    assert_path_exists testpath/".config/bookokrat/config.yaml"
    assert_match "Starting Bookokrat EPUB reader", (log_prefix/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
