class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.6/posh-debian-0.14.6.tar.bz2"
  sha256 "cacc5eeebcc36d83a2b5d63fd4d58b17762a3e294aa87d5d8af5c3f0dc21272f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{^debian/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25e477c241dd48c3274ed2f3aa95b1dcb31c67bb12591e51891f795b81b797c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f9a7f522bb7a7f20ab08a73186ab06924a4b9a914c9b2f8099fe207368ee52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90dfb7c66a30a95e102c4bff6c8cbc79f84e7352c4a7564d2c121caae1c484a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "73e677823d659ff2be2cccf797979b20e916ca536cc68a9ba3d09506a3d2fe0e"
    sha256 cellar: :any,                 arm64_linux:   "eaeb2e313aabd039f3a4779474dda6a50e541abd81500d3655ab609637172ac7"
    sha256 cellar: :any,                 x86_64_linux:  "601f3fc2b09b2101924abd4fd51b482e2aa9ad98a47e72e7526374f03c26a9ca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Upstream still uses K&R function definitions, which do not compile as C23.
    ENV["ac_cv_prog_cc_c23"] = "no"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
