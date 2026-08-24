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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3816497dcfe09704825701f9c1d7401906d7d2977d1a237554eb8c014f08934c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e276e1f6077e65371b1e2ad548736c190c22099ae144db02eef4f04fc1e92d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d346f3487d50bf95498918a3ebc8fde45369c09f0a0cf48c1ee67a6b472b3f87"
    sha256 cellar: :any_skip_relocation, sonoma:        "155b179dedb8de24c47ceba4231542916a8d529b0c6aa2b98deb2ee9c9d71f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3d04d93f1d10743cd4a7992b27864c948a1c24bf58d5807d1a70aed62c03118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49da247664e0e23d8872b0396992af76364d60c64134a2262798ca22c2252935"
  end

  depends_on "clisp"

  def install
    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", "--with-lisp=clisp", "--with-lispdir=#{elisp}", *args
    system "make", "install"
  end

  test do
    system bin/"cafeobj", "-batch"
  end
end
