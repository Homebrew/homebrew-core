class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.16/fribidi-1.0.16.tar.xz"
  sha256 "1b1cde5b235d40479e91be2f0e88a309e3214c8ab470ec8a2744d82a5a9ea05c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f6b90cece7f5eb2491a4938689366c84e5cba64e4a99009f20c92aaf341d186"
    sha256 cellar: :any,                 arm64_sequoia: "4904bb3375c1b1f2539cb657fbf17b0d93c050904febbba51e9dd690f3540e3b"
    sha256 cellar: :any,                 arm64_sonoma:  "0b03218a59bba62ca5a27b1a59d8c63f40478e3a957192121e1b2c593fcdb80c"
    sha256 cellar: :any,                 arm64_ventura: "334c412359217397f5e5c5ad082540ac3d5d494ef543d81c01f4e482b36b699b"
    sha256 cellar: :any,                 sonoma:        "abda3f3925574ac53d9fa5a7629102dda29132a64cf1a9f756eedc3258d1e855"
    sha256 cellar: :any,                 ventura:       "70e46d9ac5dafc34d891f6d4e1fea8416e23383c30a3ef7b52250295a9643643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f77859595dfecda802be39353e61b545c1cf1c67e9630f9441be68010f555d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da83ac3be7e395ab2444c0968fb3dce389161f10c2b481ddd4b18a9056bc2d60"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match "a simple TSet that", shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
