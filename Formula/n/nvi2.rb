class Nvi2 < Formula
  desc "Multibyte fork of the nvi editor for BSD"
  homepage "https://github.com/lichray/nvi2"
  url "https://github.com/lichray/nvi2/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "a1ad5d7c880913992a116cba56e28ee8e7d1f59a7f10e5a9b2ce6d105decb59c"
  license "BSD-3-Clause"

  depends_on "cmake" => :build

  uses_from_macos "libiconv"
  uses_from_macos "ncurses"

  conflicts_with "nvi", because: "nvi installs the same binaries"

  def install
    inreplace "CMakeLists.txt", "/usr/local/share", pkgshare

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "build/nvi"
    man1.install "man/vi.1" => "nvi.1"

    %w[nex nview].each do |cmd|
      bin.install_symlink "nvi" => cmd
      man1.install_symlink "nvi.1" => "#{cmd}.1"
    end

    system "make", "-C", "catalog"
    pkgshare.install "catalog"
  end

  test do
    (testpath/"test").write("This is æøå!\n")
    pipe_output("#{bin}/nvi -e test", "%s/æøå/nvi/g\nwq\n")
    assert_equal "This is nvi!\n", File.read("test")
  end
end
