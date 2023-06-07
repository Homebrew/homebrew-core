class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/xcodebuild/fcitx-remote-for-osx"
  url "https://github.com/xcodebuild/fcitx-remote-for-osx/archive/0.4.0.tar.gz"
  sha256 "453c99a0c2e227c29e2db640c592b657342a9294a3386d1810fd4c9237deeaae"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19fd67359a908b63ee833bcca9c4fb8eb0ea07c3e91aeb3c0fe8a859b889bcd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7b351e505dc719fa8835ddeb9675b58468332f3ceb6d084ae78adfb833ff98b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "693873758b57d18c931cae6a207f3e9662b4ee390c0cd78fe575768021cc45c5"
    sha256 cellar: :any_skip_relocation, ventura:        "cc5388fe0d9810de4868dc7d9e34ef08a720d080010d74e6c4a440d18cf7ee19"
    sha256 cellar: :any_skip_relocation, monterey:       "510392afb707d7dbb4559688c000b6207c8aad09f2e53e12bf01365721f53939"
    sha256 cellar: :any_skip_relocation, big_sur:        "14a03328ceabe65792010d2d33c3500755fb7605b1ba25b4606b9422a7c11646"
    sha256 cellar: :any_skip_relocation, catalina:       "152aab38c829bea77ca1578b566eda8b6bc3dea479b3c46a41b220c134135575"
  end

  depends_on :macos

  # need py3.6+ for f-strings
  uses_from_macos "python" => :build, since: :catalina

  def install
    system "python3", "build.py", "build", "general"
    bin.install "fcitx-remote-general"
    bin.install_symlink "fcitx-remote-general" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote", "-n"
  end
end
