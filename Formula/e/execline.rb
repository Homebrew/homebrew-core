class Execline < Formula
  desc "Interpreter-less scripting language"
  homepage "https://skarnet.org/software/execline/"
  url "https://skarnet.org/software/execline/execline-2.9.7.0.tar.gz"
  sha256 "73c9160efc994078d8ea5480f9161bfd1b3cf0b61f7faab704ab1898517d0207"
  license "ISC"
  head "git://git.skarnet.org/execline", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cef3552d9f1488ee1bfe7b32e50c3568f671a5d179e8f3c602c667dfe76cca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8bbbad617bb8ac9e26e9631efdf913a74a06b7f5a88b06363dd1d29aa7b2dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5fe2632e0befbca3259c9fef9072b4f64dab302bea224139726a4b89052a3ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea0514d4e9ef6f17b557d38150fa968c578cce538f460fa18e19913b884b2905"
    sha256 cellar: :any_skip_relocation, sonoma:        "56bb7856a71a5077be1f29a8e0ada34478f502f4eb60284dc1e7a9d763f2c25a"
    sha256 cellar: :any_skip_relocation, ventura:       "1765cdd721993a610bbdbd27a19939450d6f4fe8f3296151e8e09da4a0c5c0ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2121f67e055f6b0dee1a23c671629de78ce3b4c589caa17e0b0f8e77b88aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135280851c5d80d05338574a9714112313e6358d0f4d572de470998bcdf503b9"
  end

  depends_on "pkgconf" => :build
  depends_on "skalibs"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %W[
      --disable-silent-rules
      --disable-shared
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
