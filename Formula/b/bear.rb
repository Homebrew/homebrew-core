class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.1.5.tar.gz"
  sha256 "164e93b54c31a37abd0eddd9e300894b4113eec70dc70ec4c9b8ad7bbe1aab24"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef374bb4dde977124c9dddd7846b90d956009ff4719f46bb4d4f224a0fb1aa29"
    sha256 cellar: :any, arm64_sequoia: "ebdcfff2e3bd710c122f305d0e3fc5803abcbbe9842f2f949d647771c9b9318a"
    sha256 cellar: :any, arm64_sonoma:  "9c14eca0f34ded3653b2e9cab6c03257f5ca2b52941b53188b666ecef15e4e62"
    sha256 cellar: :any, sonoma:        "4fbbb172afc103ea02215614db18758742ccfde374216824bf9f654bd30629d3"
    sha256 cellar: :any, arm64_linux:   "1296b5d0218ecad5f9ac7cd3f92646835376b7dc96d9fea5c1c643e32202adde"
    sha256 cellar: :any, x86_64_linux:  "607012dbd86732e1d2f651cee025163c9302f0321c8312dcd2103fd8e7bd4b45"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  def install
    %w[driver wrapper].each do |crate|
      # Install binaries to `target/release` because `scripts/install.sh` expects them here
      system "cargo", "install", *std_cargo_args(root: "target/release", path: "crates/bear-#{crate}")
    end
    ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld" if OS.linux?
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release"

    with_env(PREFIX: prefix) do
      system "scripts/install.sh"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
