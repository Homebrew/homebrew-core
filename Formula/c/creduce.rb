class Creduce < Formula
  desc "Reduce a C/C++ program while keeping a property of interest"
  homepage "https://github.com/csmith-project/creduce"
  license "BSD-3-Clause"
  revision 5
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

    # Port to LLVM 17.0
    # Remove with the next release
    patch do
      url "https://github.com/csmith-project/creduce/commit/a4f6cf3689d44513fd944b1090ca8fd6d5ae8cd5.patch?full_index=1"
      sha256 "2752eba5204de7f0eeac215bdabc2fb02441b79cbd17e5584e021cc29b8521c5"
    end

    # Port to LLVM 18.0
    # Remove with the next release
    patch do
      url "https://github.com/csmith-project/creduce/commit/98baa64699aedb943520f175a5e731582df2806f.patch?full_index=1"
      sha256 "7a5a04ed394de464c09174997020a6cca0cc05154f58a3e855f20c8423fc8865"
    end

    # More backports needed for updating LLVM
    patch do
      url "https://github.com/csmith-project/creduce/commit/4371cc2d77c771b8b88ded79b95176bac8dfbf09.patch?full_index=1"
      sha256 "f7e88a13deb1db21933d0a81dfe328982beed283d49a66a59e6ef9c2220b1144"
    end
    patch do
      url "https://github.com/csmith-project/creduce/commit/dff59dae1fc2d62cc1cd240761492587bab364be.patch?full_index=1"
      sha256 "e4c531c73a8cd26cbf9175fa6f094f46a12cda00e5de3ac40e5c13aaf22c0b77"
    end
  end

  livecheck do
    url :stable
    regex(/^(?:creduce[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "94b893aac362ceca74c7d09acf19335865abf17e3f638db16167adf56865cd5e"
    sha256 cellar: :any,                 arm64_sequoia: "5fadf5c8c719a221bb924142eae5abffe40dff151033a6166e5e02b2a61980f8"
    sha256 cellar: :any,                 arm64_sonoma:  "70f95a86f0cada743b96616b58e8a55c6747c831af695947d02dc1a07132cd8b"
    sha256 cellar: :any,                 sonoma:        "49319eb927f3b1f423b4176c525f89c4e3e55da53441c63ee4812cc3aece5c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a75cd23590bf3bb096a62046b47589e1b03879cc7f98c354b469704083b89a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6792f620f4a932cbbb518201e715cf09e9f90208a651e317aad521a6b8cd2a9f"
  end

  depends_on "astyle"
  depends_on "llvm@20"

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

  # Apply open PR to support LLVM 19
  # PR ref: https://github.com/csmith-project/creduce/pull/285
  patch do
    url "https://github.com/csmith-project/creduce/commit/30d433e5e49c6b5864e5ca7d8aa7cf30cf3191e2.patch?full_index=1"
    sha256 "f0de5d3cf8a17405f4fce908a498feed3aa0d8594092bb3096624dba1ca5b74f"
  end

  # Apply open PR to support LLVM 20
  # PR ref: https://github.com/csmith-project/creduce/pull/287
  patch do
    url "https://github.com/csmith-project/creduce/commit/62bd78d6d621faca246a1b2b659b75bf721aa184.patch?full_index=1"
    sha256 "fe476690a81b3a6d9cda06058515fc49a250f1a0b6d9ecf30a9a9dc68ab7987d"
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

    system "./configure", "--disable-silent-rules",
                          "--bindir=#{libexec}",
                          *std_configure_args
    system "make"
    system "make", "install"

    (bin/"creduce").write_env_script("#{libexec}/creduce", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"test1.c").write <<~C
      int main() {
        printf("%d\n", 0);
      }
    C
    (testpath/"test1.sh").write <<~BASH
      #!/usr/bin/env bash

      #{ENV.cc} -Wall #{testpath}/test1.c 2>&1 | grep 'Wimplicit-function-declaration'
    BASH

    chmod 0755, testpath/"test1.sh"
    system bin/"creduce", "test1.sh", "test1.c"
  end
end
