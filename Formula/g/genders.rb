class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://github.com/chaos/genders"
  url "https://github.com/chaos/genders/archive/refs/tags/genders-1-32-1.tar.gz"
  version "1.32.1"
  sha256 "0dc186ec8fd01ec10b5e171d8b8ef632a56d17c135baee2570c0a3c0ffd9d64d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^genders[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eba68a608683a6b5b812d8aaa3a59b4836ec5bf50af50a4115fde697a790274e"
    sha256 cellar: :any,                 arm64_sequoia: "62f03cd7307b153442bf0354c80db74e9f17b6eb76fc0913e9f58d24d3eca939"
    sha256 cellar: :any,                 arm64_sonoma:  "378b3b15497a18109d4083be8b58c69926f5aba003335ad6ead80187bcba23fa"
    sha256 cellar: :any,                 arm64_ventura: "85ce393a73b4c8102f4337e4fdd14cbe801e003951b92452ae7cacd733c37b0f"
    sha256 cellar: :any,                 sonoma:        "dc5878427ff5e64542ee04d17fe4cafe426b0aa8de57ce6772d6caefa858eb67"
    sha256 cellar: :any,                 ventura:       "418c4f1cd65608a9b31203c3fe1351260ab9af1c5e0ed7dc7ad6df40b2f816d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2ae24d08bac380a175921c187843271b0248c7a9e37d5d9f2e214636f27bec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4d80a5708b75bb42090098c791379194c9da4fc9cb41a1ff40193b69d0bea3"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "python-setuptools" => :build
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV["PYTHON"] = which("python3")

    ENV.append "CXXFLAGS", "-std=c++14"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--with-java-extensions=no", *args, *std_configure_args
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
