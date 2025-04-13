class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www2.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/refs/tags/v9.5.24b.tar.gz"
  version "9.5.24b"
  sha256 "85d695ab34d62f86d5b08f5bde91200026c1fc5a67f33f47c498f96e72543c62"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a20d67451650cdfea1f41e28644395e799c8cb02de9e9dc452d5ceffee1a6833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecc07e8c403f9de87e9be35a1e130633b38dcfb081c427b11db3a72c14d457f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce83ff988cba709e562c1f9eb10b83b213dac39c0fbf5f35a0c604e5d946b395"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b3a9d4c3edecb4a85b91b50b434c0d2e1340ca56fd363255ad21e7e3d67566"
    sha256 cellar: :any_skip_relocation, ventura:       "305fba963c8ec8927afab6c2418cc27833fe06dd384549d2c84dfc6f68e556fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3add527d5661f110ee2fbd4a9c9fd45c125570c6ffae22a302e4c0f2d54fe927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4a8c1440be1ac2b3dee44a515b8b0b9a173081242f1afa024a82bb03fa88f5"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "macintosh"
    else
      "linux"
    end
    system "make", "Configure", "name=#{target}"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
