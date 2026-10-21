class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/erkin/ponysay.git", branch: "master"

  stable do
    url "https://github.com/erkin/ponysay/archive/refs/tags/3.0.3.tar.gz"
    sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"

    # upstream commit 16 Nov 2019, `fix: do not compare literal with "is not"`
    patch do
      url "https://github.com/erkin/ponysay/commit/69c23e3a.patch?full_index=1"
      sha256 "2c58d5785186d1f891474258ee87450a88f799408e3039a1dc4a62784de91b63"
      type :backport
      resolves "https://github.com/erkin/ponysay/pull/299"
    end
  end

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3700eccd17ee72657164db2487c86463d1cbbfdcf793ea4a97c0612b9fdb9371"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7ea464892cdd2b245c203e33e7679857663d444b923919da2c1285974939fe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af2695f055a97a313745266077f95638ac0103ee772184cababcb4f23e8d553c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1aef0ab9599b29a34cce59e5214dbc906454052c0cdee80c989ed760459415c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cbe2bf940b057a0d8e236d6f8398ea05aee04978a492398d1688053a2cce3dbf"
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.15"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{python3}",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
