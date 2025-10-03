class Brightness < Formula
  desc "Change macOS display brightness from the command-line"
  homepage "https://github.com/nriley/brightness"
  url "https://github.com/nriley/brightness/archive/refs/tags/1.2.tar.gz"
  sha256 "6094c9f0d136f4afaa823d299f5ea6100061c1cec7730bf45c155fd98761f86b"
  license "BSD-2-Clause"
  head "https://github.com/nriley/brightness.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0e6517dcfe7a3a982012ed8311ab590f4d071382d9e80ff60c8dba7dc0075e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "92e87e26e1e82ded8087e37e6e94624f80af2b1d84248fb70653da8c86688396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b58db49a33ceb05f73c15c3a138bf6f9c0c20902fc77395ebe980be328c3418"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9eeafad9f79ffee161eff12eb18073e5c3e22cdf00c727aead7f759e8d26b62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baf05ff80ff28745c1fed3f18467752c217236335d14d99d45fa6330a010a7bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "553772d87cb89c4f482c3b4ea48eeb404a7572b6277ced0d87625695e480b4e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6318e2be3bb6323a7d1d89dd067cc9325486c431f0c692f0978e663969ed6fd7"
    sha256 cellar: :any_skip_relocation, ventura:        "ad0f98500a441f754f2f832e9d797f4dde7261874ceaee0a4d632f025d6d6985"
    sha256 cellar: :any_skip_relocation, monterey:       "b8eb62151ad68eaec24fedcd6e4f7a7f97970f044736cec19818c88d8ba9afca"
    sha256 cellar: :any_skip_relocation, big_sur:        "687b60a636da1664c3c16ef69e84556cfe78d04e3e080de1ca0182847df2afc1"
    sha256 cellar: :any_skip_relocation, catalina:       "d9a033e343696c88863a7d231197d27be9611a2c8c56c83b4fd2747e2a2e5a7e"
  end

  depends_on :macos

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"brightness", "-l"
  end
end
