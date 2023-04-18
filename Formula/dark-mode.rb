class DarkMode < Formula
  desc "Control the macOS dark mode from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/v3.0.2.tar.gz"
  sha256 "fda7d4337fe3f0af92267fb517a17f11a267b5f8f38ec2db0c416526efd42619"
  license "MIT"
  head "https://github.com/sindresorhus/dark-mode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "220d410b3879326e6d7b359cf4ca5e4feeafa76b12998e4fcd64ef420ffc1f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1e6bb2d24e1d8c7e2c8bc07bdfffbe0a9c13136e92066b97a24dcbbda938220"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc8e59edc2327ebe14e1b5c1d40a9fe8a7138749ec5ae092ff752c28c83e97aa"
    sha256 cellar: :any_skip_relocation, ventura:        "46d4c9a2055387cd9a0abf38f563e803034e4a946313dae838f30d6025633421"
    sha256 cellar: :any_skip_relocation, monterey:       "312e08579ba705193ec21f3f10f3b52ac69b752d301788846752f3e160105abf"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ec98a0dfe32ff7933e9f44a4f4933e1e0da4929076e72ed79cbc296240c17dd"
    sha256 cellar: :any_skip_relocation, catalina:       "5533a6c879d399a84a61b0ee6d03e5baaa23c8d598ebc8c3ad1dbd0db6da8958"
    sha256 cellar: :any_skip_relocation, mojave:         "692456cb6abf428b487c663b4718147fe4fffa5be956054700857d2d9ddb977f"
  end

  depends_on xcode: :build
  depends_on :macos
  depends_on macos: :mojave

  def install
    # https://github.com/sindresorhus/dark-mode/blob/main/build
    Dir.mktmpdir do |tmpdir|
      xcodebuild "-arch", Hardware::CPU.arch,
                 "-derivedDataPath", tmpdir,
                 "-scheme", "dark-mode",
                 "-configuration", "Release",
                 "OBJROOT=.build",
                 "SYMROOT=.build"
    end
    bin.install ".build/Release/dark-mode"
  end

  test do
    assert_match(/\A(on|off)\z/, shell_output("#{bin}/dark-mode status").chomp)
  end
end
