class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.2.4.tar.gz"
  sha256 "1a771dba88f9687e58b6c35537336bab7a26dc196b2d37f868c7a83a310ab959"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "179961370d51510164f0a224b3a96085c85148d3b1bc98bbae113f0b2eb478dd"
    sha256 cellar: :any, arm64_tahoe:       "f895e4ddea72676743f8477440816ab77d0369fb1f7cb23ab27b5dd7522452ed"
    sha256 cellar: :any, arm64_sequoia:     "f05e97f4fa36e553db6ce2e9c011a12a2a07ab65fc2cc2631b3291cbc6ed5cc3"
    sha256 cellar: :any, arm64_linux:       "e87c9299f1ee5a77adfde3f1e0eb8f42eba3a444e9854774bdea0ea6cd278348"
    sha256 cellar: :any, x86_64_linux:      "0c28c8f660f57f19c5af70f1d74dc1a70139bb4998e49c8e16917bea486629d9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
