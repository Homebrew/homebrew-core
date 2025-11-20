class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/xcodebuild/fcitx-remote-for-osx"
  url "https://github.com/xcodebuild/fcitx-remote-for-osx/archive/refs/tags/0.4.0.tar.gz"
  sha256 "453c99a0c2e227c29e2db640c592b657342a9294a3386d1810fd4c9237deeaae"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ec25385e4a84e52059462f9cfaa20504a4a422f211ec11437c9e3550cffc6fcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ba0909f82f992a9c0cf6e883da59d3b9ceeb33a6a3e0e01a6ee4e885953b923e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08938e1cc1bcafa79ae3fe4adcf00b6e12bc8144a70aa796d3b974471a7d9bb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19fd67359a908b63ee833bcca9c4fb8eb0ea07c3e91aeb3c0fe8a859b889bcd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7b351e505dc719fa8835ddeb9675b58468332f3ceb6d084ae78adfb833ff98b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "693873758b57d18c931cae6a207f3e9662b4ee390c0cd78fe575768021cc45c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "be5d0e593f22a65f01d698aa72f1a559f4c070019590997274cfe6f79fadee98"
    sha256 cellar: :any_skip_relocation, ventura:        "cc5388fe0d9810de4868dc7d9e34ef08a720d080010d74e6c4a440d18cf7ee19"
    sha256 cellar: :any_skip_relocation, monterey:       "510392afb707d7dbb4559688c000b6207c8aad09f2e53e12bf01365721f53939"
    sha256 cellar: :any_skip_relocation, big_sur:        "14a03328ceabe65792010d2d33c3500755fb7605b1ba25b4606b9422a7c11646"
    sha256 cellar: :any_skip_relocation, catalina:       "152aab38c829bea77ca1578b566eda8b6bc3dea479b3c46a41b220c134135575"
  end

  depends_on :macos

  # need py3.6+ for f-strings
  uses_from_macos "python" => :build

  def install
    system "python3", "build.py", "build", "general"
    bin.install "fcitx-remote-general"
    bin.install_symlink "fcitx-remote-general" => "fcitx-remote"
  end

  test do
    system bin/"fcitx-remote", "-n"
  end
end
