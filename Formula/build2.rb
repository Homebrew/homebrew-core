class Build2 < Formula
  desc "C/C++ Build Toolchain"
  homepage "https://build2.org"
  url "https://download.build2.org/0.14.0/build2-toolchain-0.14.0.tar.gz"
  sha256 "36781e9fce483e431dcf1d4d73dbef267b1712fb8679dbe968334aae6242237f"
  license "MIT"

  def install
    # Don't build the build tool hermetically, to avoid baking Homebrew-specific
    # paths into the final dylibs
    inreplace "./build.sh", "config.config.hermetic=true", "config.config.hermetic=false"

    args = %W[
      --jobs #{ENV.make_jobs}
      --sudo false
      --local
      --private
      --make make
      --install-dir #{prefix}
    ]

    system "./build.sh", *args, ENV.cxx
  end

  test do
    (testpath/"test.cxx").write("int main() {}")
    (testpath/"buildfile").write("using cxx\nexe{test}: cxx{test.cxx}")
    system "#{bin}/b"
  end
end
