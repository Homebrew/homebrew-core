class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://github.com/CafeOBJ/cafeobj/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b5ea4267b7b4ff3d85a970b6330f706b81ef872968230608005c9b3d168b0065"
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
    sha256 arm64_sequoia: "91c9ae231c3b44acf6923ac1c9131fc8cbe7edf2f992a617ce791289971dea73"
    sha256 arm64_sonoma:  "01e514ed674dceb8795c1803057a00efc3eb29b69dc250bee9f843a5c67d7de1"
    sha256 arm64_ventura: "d965be913974b99253cb094994af1e82bcb6c8736d8658d4e4d80deae69dac93"
    sha256 sonoma:        "775c475b5a3af142c817148e402fa6de72dd767a537e1d7e5d2892472b5f5059"
    sha256 ventura:       "b711614790294d992198d166691e66e9e9e78abb1c039fc7e5b30eab1e26183f"
    sha256 x86_64_linux:  "779108ed08023bc358ac5276e28d7d7f0f4febc0dc99ea67ef04da3ac8d56ae2"
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
