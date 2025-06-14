class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  url "https://github.com/sstadick/perbase/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "c4e1a7409d6bb3b0b252fa5efa7781b806897bd2c6cddef62b9abf9c0d7b8a40"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e10cf0a82a532a75ceefcbbbd3f57966848dfc051b17adb69ef89331cc3caad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36518d86e409d3fa652505da67ce0496dbdaf0d77e3a71ec554e29513d0b66fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e3175e41b1eb99a08d1da49411c2b823d4761832f50d90c590f6e7c9b6b486d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c0ee0199bc40ac70d07d35c029dede0cb84748592b10cfa2c1c0a8f3af91ad7"
    sha256 cellar: :any_skip_relocation, ventura:       "491387c47a53f4c3e838874a33c206d40c08317aa419988f44dac62e15fa30b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a110b4abaaede69fb54db905c39ba0f274fde0bf422e1f99e18bb285cb26279"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test.bam", testpath
    system Formula["bamtools"].opt_bin/"bamtools", "index", "-in", "test.bam"
    system bin/"perbase", "base-depth", "test.bam", "-o", "output.tsv"
    assert_path_exists "output.tsv"
  end
end
