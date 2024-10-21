class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.0.tar.gz"
  sha256 "b38d69d7fc0785eb5eb3c57e8b12a7334f862047bf84b18f414365335399469a"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9e420de1a3555054ef2a2c1bb06ae52d566d68703a60b27408f4c0a16201f4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ff1418c1d4036d1be8712e0f41904ea27f686e4596d331e2f4af2487fc03e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42db9d825c20a38cb0cb8f5f7dc2d9c68afc0030554fea61db7858c082713d11"
    sha256 cellar: :any_skip_relocation, sonoma:        "860cded87f996a8ad031bd791796e5f67589fe36bcf24aa8f0afe7a147d2edd0"
    sha256 cellar: :any_skip_relocation, ventura:       "f357dc2da58b2128ca760ee0ea86519acf9ecf3006b25075a0f9708d7268890b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aaf715a715bee53f9dc09436dbcf07475a61e2a23884137845562e4c15acd9b"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
