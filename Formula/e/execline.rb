class Execline < Formula
  desc "Interpreter-less scripting language"
  homepage "https://skarnet.org/software/execline/"
  url "https://skarnet.org/software/execline/execline-2.9.8.1.tar.gz"
  sha256 "23350d10797909636060522607591cb4a2118328cb58c5e65fb19a2c0d47264e"
  license "ISC"
  head "git://git.skarnet.org/execline", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1821cb1a1f4cb4563107a96a6e4226fbb19f71e2b4f4958ba3072e2320d3cde8"
    sha256 cellar: :any,                 arm64_sequoia: "7e85921f90d391666a22e1daf7b572164be83fc0bccf6d716afa70eb590ae347"
    sha256 cellar: :any,                 arm64_sonoma:  "b87efb740ad77909dbcd391cf64b3f258e8de85d88e9222c54a6199e8ec870bb"
    sha256 cellar: :any,                 sonoma:        "02723eef03476c8dcd5448899b4717e06d9c4c3b94e2d39b4421dc730e27da4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49daa9344067f4534f19592352185b0b5a573f2e8420929d65238294770723ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ecaef5ce93cc303329fc01de0290f3b4bd4c7c3b2ef7510eefa5d60b1869ca1"
  end

  depends_on "pkgconf" => :build
  depends_on "skalibs"

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")
  end
end
