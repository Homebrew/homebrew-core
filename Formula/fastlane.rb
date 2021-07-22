class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.188.0.tar.gz"
  sha256 "5a096f0e7682845845a082e5d041a7ad53a0277c8cbe379d6de106cd7f360c58"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "f470190cf8a65d8e149374ab6ea701ca53a9a1c05014057715e4535da5778505"
    sha256 cellar: :any,                 big_sur:       "21b7796249e1ca2c884a78aee115bcd8418215d0320fcf6fa77a55e04b891267"
    sha256 cellar: :any,                 catalina:      "4de029317572573afd507a20135ff39a262886a9a820017bdd44f470a498c833"
    sha256 cellar: :any,                 mojave:        "674c6385ad5869f39a773c4be4f775dbb258320a16c304b96d7962507b9b1b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f41950ac80b538a286b4be1d4d5ddcdaf032fa453b8be84b9dc9e6443dace5ab"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
