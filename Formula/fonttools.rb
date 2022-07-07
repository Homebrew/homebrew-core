class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c0/95/9dc382935deeede8a8ad93d90ec1d1c5019181ad634e3b917b77d3430082/fonttools-4.34.3.zip"
  sha256 "cb6eee1330423ffaa56af962aeb2b8db409dc8f98b9d8e79ea109a09d4168191"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb1de4a7358fb523895bfc993fb78192c0606c9b38a68edcd250e3fb63bc8323"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb1de4a7358fb523895bfc993fb78192c0606c9b38a68edcd250e3fb63bc8323"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c0659189afe67f7146b7e3634d40baac5ca2fb363886e5966f8931e66624b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3c0659189afe67f7146b7e3634d40baac5ca2fb363886e5966f8931e66624b8"
    sha256 cellar: :any_skip_relocation, catalina:       "b3c0659189afe67f7146b7e3634d40baac5ca2fb363886e5966f8931e66624b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a81bf45de9bee4f008b0467bcd992222862c6bb2dd0d94561488814a89a5237"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
