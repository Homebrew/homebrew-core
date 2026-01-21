class Cln < Formula
  desc "Class Library for Numbers"
  homepage "https://www.ginac.de/CLN/"
  url "https://www.ginac.de/CLN/cln-1.3.7.tar.bz2"
  sha256 "7c7ed8474958337e4df5bb57ea5176ad0365004cbb98b621765bc4606a10d86b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cln[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "198d7aa1178fc5df110461b2718466f2cefdedf75a0e4c88287dc130da5ddefc"
    sha256 cellar: :any,                 arm64_sequoia:  "2279ade96381f9ac79cf40c1e29b2ea4fc998a25895b54a7fc0f77cc72d1782d"
    sha256 cellar: :any,                 arm64_sonoma:   "128ed65c291ea5059320c7618340ca04b5a59126a36b6e22de91622175d62339"
    sha256 cellar: :any,                 arm64_ventura:  "c47f98e423d29abd0de4bb322a4587817db8652d09909b07ec2eff44ff08b0fa"
    sha256 cellar: :any,                 arm64_monterey: "a7a3af1288376ee0313842c9212c7e33743fcb6d8d17df95348d5360ea657d9c"
    sha256 cellar: :any,                 sonoma:         "5c8b028628b234da5d4f97a734728ff9f73f381a3bae4ed565c8e21040190fc3"
    sha256 cellar: :any,                 ventura:        "815ff9c38056bcaa56fb7a445ebb32efa14323f26d42da224014e9ff9a57a236"
    sha256 cellar: :any,                 monterey:       "16fc46bc77d40dc5ad8060ac9375fe869c136fd1ea9f1da3df466e2a4bdb3960"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c34b349259faf1c3c86953d6ce41a6b6136ef5a20b775e7907f9476b9d8eaa57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1303657d924cdb1730d63a5b49b652cb84d07ff7694c528e997e37d796b68ec"
  end

  head do
    url "git://www.ginac.de/cln.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "wget" => :build

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
