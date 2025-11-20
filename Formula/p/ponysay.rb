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
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436a1f52adab32d7d21c3ebe39dee39f8d2bec2cdcfe0c650973b47961aa3852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f62fa211582ff29e9494cd2215609d16b6296ea0affb2582b1335db3270ee4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ce3e3d143f8164f2c88c4357e780ff8ba9b606892f88550aa6bb9bc00ffb57f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ed42c1e433ff890d69b8efd820ec6f95171904c8ec0af96da7c72701bf2369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b029e23e21fd4ac75a4cd6d69a10b766cbff2199b342db7ccca88b33aacf26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8cc2a4ab043dbb08c57344164315a5653bbcb1f9dd36103d9e697eb010f2c1"
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.14"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.14"].opt_bin}/python3.14",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
