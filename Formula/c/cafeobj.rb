class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://github.com/CafeOBJ/cafeobj/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "12780724a2b63ee45b12b79fd574ea1dc2870b59a4964ae51d9acc47dbbcff3d"
  license all_of: [
    "BSD-2-Clause",
    :public_domain, # comlib/let-over-lambda.lisp
    "MIT", # asdf.lisp
  ]
  head "https://github.com/CafeOBJ/cafeobj.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "1b36ca85d0a9c664f7bd2622b26cece63f73d930e31b464bab88bcc1f02bc4a4"
    sha256 arm64_sonoma:   "5e0f6023e2d9a5b48533e89e09aeca6d7d5c7d5c3c5f91e106e755c6114ca168"
    sha256 arm64_ventura:  "4be3e504840ca27a601164e8bca0f8edaf6c6f6cda044f7c50736041957e8492"
    sha256 arm64_monterey: "795c8a702f4db1bdb7e64c100f5959cfdbdeacefe813f4acbbd09fb38460eef3"
    sha256 arm64_big_sur:  "0a68da082b8adb250f4041991f1f7a9b61e8f9a93012b9cd15e9c1b80b27680b"
    sha256 sonoma:         "9ba935326d5f03c78822dbbdfe922fd0546e775d0b8e22c3e2582a8d60ea4556"
    sha256 ventura:        "09a50d00fb9193709372416b990d34e74beb4ff09b8ae9ea280d238363cd356b"
    sha256 monterey:       "afad90131b9fb0a6566817ddc18dc9d98be0170eb3e6071f457fa31bf81a868e"
    sha256 big_sur:        "f4337d1c194cc66630e2ea78b2d532b59971ec19ad422a11ea515d23cad46f3c"
    sha256 x86_64_linux:   "30bf501217fe13524dcfc5667bb149a6ddcd3523916e04a86fc5b1dd06649240"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", "--with-lisp=sbcl", "--with-lispdir=#{share}/emacs/site-lisp/cafeobj", *args
    system "make", "install"
  end

  test do
    # Fails in Linux CI with "Can't find sbcl.core"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"cafeobj", "-batch"
  end
end
