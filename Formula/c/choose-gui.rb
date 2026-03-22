class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/chipsenkbeil/choose"
  url "https://github.com/chipsenkbeil/choose/archive/refs/tags/1.5.0.tar.gz"
  sha256 "34dd16ac0b5e1b8b2468d677a985690e3bac01cb0c45e2eaf5d493df968cca2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a304499bd015b6f52efa885ef54587d334935a0aac8317c71093d76047621cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d10306e841ecc9d2386cd713ca9174944a7fd1dfa00f27edbcdfad164abb516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81fb4fca698277ad669366d63027a63a071e5fdc1d94e2adf8adc21948004df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "852c47ffe1bc97a5ec0bbda87d566099d049b03c2a42c98cfa1be1daab225f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "226d6aa34398a30e22e4e675451d96f698a39e0e316381ca95b5579f904e2d16"
    sha256 cellar: :any_skip_relocation, ventura:       "e4af99e87b62cf372f365988114caf338c1a66bb87a2b624aedff0b0f5dd2bd4"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "choose-rust", because: "both install a `choose` binary"

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build", "clean"
    xcodebuild "-arch", Hardware::CPU.arch, "SDKROOT=", "SYMROOT=build", "-configuration", "Release", "build"
    bin.install "build/Release/choose"
  end

  test do
    system bin/"choose", "-h"
  end
end
