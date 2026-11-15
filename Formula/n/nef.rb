class Nef < Formula
  desc "Steroids for Xcode Playgrounds"
  homepage "https://nef.bow-swift.io"
  url "https://github.com/bow-swift/nef/archive/refs/tags/0.7.1.tar.gz"
  sha256 "147b8723d65ababedd04abf2ea4445c2b16dd7c18814a92182ae61978eb1152e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "767306a07631b9377bc9456ce65bd20b0901684982f5a9bba2f7a5f8915ff1f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c58d00692ad2f49ab2550935f72c807ebbd8f1229bc065638cb49b70a1293ce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21b1b3a4ecb000a4e2e9fbba2cc7ab2f108d8a5e8c70ad7122e27dc8f4dd2dd3"
  end

  depends_on :macos
  depends_on xcode: "13.1"

  def install
    # Work around Homebrew's sandbox causing build to lock up
    inreplace "Makefile", /^\t\$\(MAKE\) (bash|zsh)$/, ""

    system "make", "install", "prefix=#{prefix}", "version=#{version}"
  end

  test do
    # Nothing works in Homebrew's sandbox
    assert_path_exists bin/"nef"
  end
end
