class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.2.1.tar.gz"
  sha256 "508c67dc98f96253f6a6ae39f5871ac8da77f06637fb3967a4d0d4f262bf1f66"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ace3abeadfde063c9f0acfcd32225cfc20de8c260504cb0e05145a18588b6de8"
    sha256 cellar: :any, arm64_sequoia: "08c1f66fac87e8966917a5d1bcd8568f0c4f5f80c634f7219f51496eda195886"
    sha256 cellar: :any, arm64_sonoma:  "07aed1270804ab1a4f7374abc9ee4ff2ebc8ac6501d6759e378775a5339a8c17"
    sha256 cellar: :any, sonoma:        "a733c69332d05ad1d3436dde0651864e5b5dd9c5d994a1505709a7b84f22a176"
    sha256 cellar: :any, arm64_linux:   "8391d9c306b191c69a13a63c5a4765b34c2d01c0bc5a7425780519d16d26e0d8"
    sha256 cellar: :any, x86_64_linux:  "68c2739cfa3bd94cc94347f0fd3e2e954ede531a1979644534df013453a79ba8"
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
