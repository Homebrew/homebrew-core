class Creduce < Formula
  desc "Reduce a C/C++ program while keeping a property of interest"
  homepage "https://github.com/csmith-project/creduce"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/csmith-project/creduce.git", branch: "master"

  # Remove when patches are no longer needed.
  stable do
    # TODO: Check if we can use unversioned `llvm` at version bump.
    url "https://github.com/csmith-project/creduce/archive/refs/tags/creduce-2.10.0.tar.gz"
    sha256 "de320cd83bd77ec1a591f36dd6a4d0d1c47a0a28d850a6ebd348540feeab2297"

    # Use shared libraries.
    # Remove with the next release.
    patch do
      url "https://github.com/csmith-project/creduce/commit/e9bb8686c5ef83a961f63744671c5e70066cba4e.patch?full_index=1"
      sha256 "d5878a2c8fb6ebc5a43ad25943a513ff5226e42b842bb84f466cdd07d7bd626a"
    end

    # Port to LLVM 15.0.
    # Remove with the next release.
    patch do
      url "https://github.com/csmith-project/creduce/commit/e507cca4ccb32585c5692d49b8d907c1051c826c.patch?full_index=1"
      sha256 "71d772bf7d48a46019a07e38c04559c0d517bf06a07a26d8e8101273e1fabd8f"
    end
    patch do
      url "https://github.com/csmith-project/creduce/commit/8d56bee3e1d2577fc8afd2ecc03b1323d6873404.patch?full_index=1"
      sha256 "d846e2a04c211f2da9a87194181e3644324c933ec48a7327a940e4f4b692cbae"
    end
  end

  livecheck do
    url :stable
    regex(/^(?:creduce[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "86f827dbec5d9cd7c0441524da51406b3053f9eb4473fe5f261ffb92de6758f7"
    sha256 cellar: :any,                 arm64_ventura:  "7237b5dcaa9b242dbf6d802b899055e27464968a8c260843836e266def749f28"
    sha256 cellar: :any,                 arm64_monterey: "1cea9260c4c9bb7163c3e0892ac5a43d42fe3061bfa3b1d4cf8c27c921b6aa45"
    sha256 cellar: :any,                 arm64_big_sur:  "01a3f3bf670aa664211b14c98095d555d3a1eaddeae77a4b97beb9244fa73c66"
    sha256 cellar: :any,                 sonoma:         "866a2058a1604832fc533fab192d35370036aefc12a91f2af833652f5942a6d5"
    sha256 cellar: :any,                 ventura:        "08f96b6e80c46641a5131c7c2ec1cda64f7837888b2679eff86d33bb5a03382c"
    sha256 cellar: :any,                 monterey:       "66ab9b7fc1131261676c4993d5a15f324a095016b536592180e30d641aafb257"
    sha256 cellar: :any,                 big_sur:        "8bdeb52e5688a4cefac68a1c42f8785ff5ac246bb1f11a42b766f9bacf499905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4cd8463c7ec4aa2ca405acc8bccb0f7cefed61ea77693fe27d30f1a9160eddf"
  end

  depends_on "astyle"
  depends_on "llvm@15"

  uses_from_macos "flex" => :build
  uses_from_macos "perl"

  resource "Exporter::Lite" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Exporter-Lite-0.08.tar.gz"
    sha256 "c05b3909af4cb86f36495e94a599d23ebab42be7a18efd0d141fc1586309dac2"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.23.tar.gz"
    sha256 "b79dc2244b2d97b6f27167fc3b7799ef61a179040f3abd76ce1e0a3b0bc4e078"
  end

  resource "Getopt::Tabular" do
    url "https://cpan.metacpan.org/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    sha256 "9bdf067633b5913127820f4e8035edc53d08372faace56ba6bfa00c968a25377"
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "URI::Escape" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.72.tar.gz"
      sha256 "35f14431d4b300de4be1163b0b5332de2d7fbda4f05ff1ed198a8e9330d40a32"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    # Avoid ending up with llvm's Cellar path hard coded.
    ENV["CLANG_FORMAT"] = llvm.opt_bin/"clang-format"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    # Work around build failure seen on Apple Clang 13.1.6 by using LLVM Clang
    # Undefined symbols for architecture x86_64:
    #   "std::__1::basic_stringbuf<char, std::__1::char_traits<char>, ...
    if DevelopmentTools.clang_build_version == 1316
      ENV["CC"] = llvm.opt_bin/"clang"
      ENV["CXX"] = llvm.opt_bin/"clang++"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--bindir=#{libexec}"
    system "make"
    system "make", "install"

    (bin/"creduce").write_env_script("#{libexec}/creduce", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"test1.c").write <<~EOS
      int main() {
        printf("%d\n", 0);
      }
    EOS
    (testpath/"test1.sh").write <<~EOS
      #!/usr/bin/env bash

      #{ENV.cc} -Wall #{testpath}/test1.c 2>&1 | grep 'Wimplicit-function-declaration'
    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/creduce", "test1.sh", "test1.c"
  end
end
