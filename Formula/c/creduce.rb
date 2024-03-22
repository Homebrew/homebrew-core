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

    # Port to LLVM 16.0
    # Remove with the next release
    patch do
      url "https://github.com/csmith-project/creduce/commit/8ab9a69caf13ce24172737e8bfd09de51a1ecb6a.patch?full_index=1"
      sha256 "fb5dfed2f0255ea524f0c0074a5b162ae2acbcabb9ff1f31adf45ca025dd4419"
    end
  end

  livecheck do
    url :stable
    regex(/^(?:creduce[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "27b403d9535a97881c5656bfabd1d4c5c6edb860254ac41639976baf75974209"
    sha256 cellar: :any,                 arm64_ventura:  "c2ccddd68a8744ef7f6162077ed45e9e7e02121b5c486a946a5aeb0e3bec590e"
    sha256 cellar: :any,                 arm64_monterey: "53e4617c1868c9d26c840570168315143d56807da30f81193a2d2dc0ac26aec6"
    sha256 cellar: :any,                 sonoma:         "e6a866446fcf3a71ceb219a956daea190a4679afb8da9d2a8a66e32fa38d7f8a"
    sha256 cellar: :any,                 ventura:        "e4c45db2c535040e462a4e733057ffb20e7b2a480f890620b6bce082bee93867"
    sha256 cellar: :any,                 monterey:       "13c7946bf394639b9ee3f00adfe3ee218f556da42d37567a960e7936b858e69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86d9791a96c85e1eb9753c8acf09820b3969ba0623c77085b0b0b4f248e495e"
  end

  depends_on "astyle"
  depends_on "llvm@16" # LLVM 17: https://github.com/csmith-project/creduce/pull/264

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
