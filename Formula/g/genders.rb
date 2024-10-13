class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://github.com/chaos/genders"
  url "https://github.com/chaos/genders/archive/refs/tags/genders-1-29-1.tar.gz"
  version "1.29.1"
  sha256 "42c37c53a831e007b4fd5a5596060417186724e18cbd5c9dbb3a7185144200c2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^genders[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e4fb31da5615e88dcc18ad6c9ef273e4af10e79bd9c3e5a1a6184988277295de"
    sha256 cellar: :any,                 arm64_sonoma:   "24687149f4c7eae6083d96d72ab233d6f15f009d86fc0aca12459f9bf7da5996"
    sha256 cellar: :any,                 arm64_ventura:  "987feaf1eba85ac7554b72e1b341779dec8e5b5785daa0cf490079345256f1d5"
    sha256 cellar: :any,                 arm64_monterey: "568666f7f26b9d68df7c5bce2db3f953b09fe9ef5e92d8adf2f48f81a6e1d388"
    sha256 cellar: :any,                 sonoma:         "9fcca30c146588f81f9fadf833022d70898612723f2526eef1e2836fc395b4ea"
    sha256 cellar: :any,                 ventura:        "dbe0fbc6daf625e29b3db27cb6b7ddc8416145f41db930bdec9d0d66c905eacf"
    sha256 cellar: :any,                 monterey:       "fbfe9f9bd3d171bc75d73c7cee9dc009370f052d134aee3a5fda3aabe95bf5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb2859efed178704493b7801a8b182f82068c1d6bae6962a30ff8a169b79eef"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build

  # upstream issue to drop distutils usage, https://github.com/chaos/genders/issues/65
  on_linux do
    depends_on "python-setuptools" => :build
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV["PYTHON"] = which("python3")

    system "./configure", "--with-java-extensions=no", *std_configure_args
    system "make", "install"

    # Move man page out of top level mandir on Linux
    man3.install (prefix/"man/man3").children unless OS.mac?
  end

  test do
    (testpath/"cluster").write <<~EOS
      # slc cluster genders file
      slci,slcj,slc[0-15]  eth2=e%n,cluster=slc,all
      slci                 passwdhost
      slci,slcj            management
      slc[1-15]            compute
    EOS
    assert_match "0 parse errors discovered", shell_output("#{bin}/nodeattr -f cluster -k 2>&1")
  end
end
