class Purr < Formula
  desc "Versatile zsh CLI tool for viewing and searching through Android logcat output"
  homepage "https://github.com/google/purr"
  url "https://github.com/google/purr/archive/refs/tags/2.0.4.tar.gz"
  sha256 "ce8b4d31d6b56e79808f12a37795ea15127f3e01eb94f2becb1ee1cd8724844a"
  license "Apache-2.0"
  head "https://github.com/google/purr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa9f2b9771176c44263d83ed3735762d21d6811a5a57dcbfe8fae6e99a6a8690"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9f2b9771176c44263d83ed3735762d21d6811a5a57dcbfe8fae6e99a6a8690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9f2b9771176c44263d83ed3735762d21d6811a5a57dcbfe8fae6e99a6a8690"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa9f2b9771176c44263d83ed3735762d21d6811a5a57dcbfe8fae6e99a6a8690"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9f2b9771176c44263d83ed3735762d21d6811a5a57dcbfe8fae6e99a6a8690"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9f2b9771176c44263d83ed3735762d21d6811a5a57dcbfe8fae6e99a6a8690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "990020551f251f6ece2dfbc38957f50d7997b9945fbf6128e46ddea3f6832598"
  end

  depends_on "fzf"
  uses_from_macos "zsh"

  def install
    system "make"
    bin.install "out/purr"

    # This is needed for test
    system "make", "adb_mock", "file_tester", "OUTDIR=#{pkgshare}"
    chmod 0755, "#{pkgshare}/adb_mock"
    chmod 0755, "#{pkgshare}/file_tester"
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purr -v")
    system pkgshare/"file_tester", "-a", pkgshare/"adb_mock", "-p", bin/"purr"
  end
end
