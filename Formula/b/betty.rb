class Betty < Formula
  desc "English-like interface for the command-line"
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "ed71e88a659725e0c475888df044c9de3ab1474ff483f0a3bb432949035e62d3"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "6e05c82883d813ce98372d8ed15bf2e4b9cd11cd91f36483a07e37ccec8204ee"
  end

  uses_from_macos "ruby"

  def install
    libexec.install "lib", "main.rb" => "betty"
    bin.write_exec_script libexec/"betty"
  end

  test do
    system bin/"betty", "what is your name"
    system bin/"betty", "version"
  end
end
