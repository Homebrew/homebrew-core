class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "f8a3afdd3967fe7d88bd1b0b9f5cb62ae04dc9ba458238da91efc213f61a9cf9"
  license "MIT"
  head "https://github.com/rwos/gti.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "92eaaa595256c1a44b2c7b239d5569a9f023dfde904a9ba74ce9a0da44395a9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3f8050edc162e75b939fece0bc60b6aecfca2c5e38e0259085731a8a69e6ac13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1446d1aac84e5119614a6bbfd66171910abc23826d06754d3319142ca0ec7f63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61791d20101f0ccaaf39d73a13da70f7ea88589b0eb7b0badbabd03719ebf24a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e4bd49913f7b31c872610abfde90700828d3235962c5c961f4b42138fa8e31"
    sha256 cellar: :any_skip_relocation, sonoma:         "11055e312584cca72aa358c1cc27ea9bc4d76bdb5f5f030ce3633cf6fc994f17"
    sha256 cellar: :any_skip_relocation, ventura:        "e9086b3d38889bfc0562db4390b3a0f692fd1d2a5324daee6e29c75cc2c8f161"
    sha256 cellar: :any_skip_relocation, monterey:       "6167571b70f956b1740a421b75c7e190dbfb1f5654f76563e81d748693803d2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "86c9c281f743ac0808f749dfff7744cc6c4aa72ed6cc450fc0ad324dc3e0f815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca34ee86c2f431b36b38d90251d42b6e68b52cb506d8f5197c4cfc1f807fe718"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"

    bash_completion.install "completions/gti.bash" => "gti"
    zsh_completion.install "completions/gti.zsh" => "_gti"
  end

  test do
    system bin/"gti", "init"
    assert_path_exists testpath/".git"
  end
end
