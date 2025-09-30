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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "dce62a3729ca96afc0a108ddd59600066e98b82282fd448f3af759660d112537"
    sha256 cellar: :any,                 arm64_sequoia: "f09b8ca7dd1989923e0c4655ea33c8a42a0c1d11bfbf42565abaccc48d0b530f"
    sha256 cellar: :any,                 arm64_sonoma:  "259398f625fe7637f8a2858d3ef6527afc3f37f6ca5ad6c981f531ac9d39fa90"
    sha256 cellar: :any,                 sonoma:        "04d7d82a328ad96e7dcf8fa3d9afabb1f84b0d386c1beed9eef271737ab9ac56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9e673420ee0cba67dc62168fc40be7d88e685929420bd0bc80ea7eba80fdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fefc0da02032b0c3f03aee866a9e6db0fbc3b9bcee757a71f5a682703e12ff0b"
  end

  depends_on "sbcl" => :build
  depends_on "zstd"

  # Does not build with SBCL 2.5: https://github.com/CafeOBJ/cafeobj/issues/8
  resource "sbcl" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.11/sbcl-2.4.11-source.tar.bz2"
    sha256 "4f03e5846f35834c10700bbe232da41ba4bdbf81bdccacb1d4de24297657a415"
  end

  def install
    resource("sbcl").stage do
      ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
      system "sh", "make.sh", "--prefix=#{buildpath}/sbcl", "--with-sb-core-compression", "--with-sb-thread"
      system "sh", "install.sh"
      ENV.prepend_path "PATH", buildpath/"sbcl/bin"
    end

    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", "--with-lisp=sbcl", "--with-lispdir=#{elisp}", *args
    system "make", "install"

    # Work around patchelf corrupting the SBCL core which is appended to binary
    # TODO: Find a better way to handle this in brew, either automatically or via DSL
    if OS.linux? && build.bottle? && build.stable?
      cp lib/"cafeobj-#{version.major_minor}/sbcl/cafeobj.sbcl", prefix
      Utils::Gzip.compress(prefix/"cafeobj.sbcl")
    end
  end

  def post_install
    if (prefix/"cafeobj.sbcl.gz").exist?
      system "gunzip", prefix/"cafeobj.sbcl.gz"
      (prefix/"cafeobj.sbcl").chmod (lib/"cafeobj-#{version.major_minor}/sbcl/cafeobj.sbcl").lstat.mode
      (lib/"cafeobj-#{version.major_minor}/sbcl").install prefix/"cafeobj.sbcl"
    end
  end

  test do
    system bin/"cafeobj", "-batch"
  end
end
