class Dcfldd < Formula
  desc "Enhanced version of dd for forensics and security"
  homepage "https://github.com/resurrecting-open-source-projects/dcfldd"
  url "https://github.com/resurrecting-open-source-projects/dcfldd/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "e5813e97bbc8f498f034f5e05178489c1be86de015e8da838de59f90f68491e7"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "015e2488081449c7a4a21ab1494158bfe4c12ce23ab2f173b1d90aa606350340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27d926c612143e59fa534f10bf44f138501302ab3d7a5990c46ee4c43a66aaae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3111fcd6917b2ac2b3d6d9076c2dcb144a97c1887e15f982ffd3d36e9d90c4e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03d0c6c64483793ba34e2a79dd3dfd73753df1cfbf66995c517c7290a752c2c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b4bf86232cb89e6da8244cc8cf38f4cc075636792c8f5f52f19a424ac315c9d"
    sha256 cellar: :any_skip_relocation, ventura:       "c89731f9220e739bc26473f6e17adbb3246cf93dfe9835b77a96552edfb9994b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f82b6d7c901bd91e1425a1a135656959b45485a8f79d38c805a7991726e13a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44661f718a486d0d5bcc1b024d830cd7e72c4621577bb6d40d032b68a641f510"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dcfldd", "--version"
  end
end
