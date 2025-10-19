class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com"
  url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v1.3.0",
      revision: "b0a6feca57bf5c2a9ec2ef9773499cab7d904b30"
  license all_of: [
    "MIT",          # Bun itself and most of the dependencies
    "Apache-2.0",   # boringssl, simdutf, uSockets, and others
    "BSD-3-Clause", # boringssl, lol-html
    "BSD-2-Clause", # libbase64
    "Zlib",         # zlib
  ]
  head "https://github.com/oven-sh/bun.git", branch: "main"

  depends_on "automake" => :build
  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "go" => :build
  depends_on "icu4c@77" => :build
  depends_on "libtool" => :build
  depends_on "lld@19" => :build
  depends_on "llvm@19" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ruby" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libiconv" => :build
  end

  # Update the resource only if build fails
  resource "bun-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.0/bun-darwin-aarch64.zip"
        sha256 "85848e3f96481efcabe75a500fd3b94b9bb95686ab7ad0a3892976c7be15036a"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.0/bun-darwin-x64.zip"
        sha256 "09d54af86ec45354bb63ff7ccc3ce9520d74f4e45f9f7cac8ceb7fac422fcc19"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.0/bun-linux-aarch64.zip"
        sha256 "68b7dcd86a35e7d5e156b37e4cef4b4ab6d6b37fd2179570c0e815f13890febd"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.0/bun-linux-x64.zip"
        sha256 "60c39d92b8bd090627524c98b3012f0c08dc89024cfdaa7c9c98cb5fd4359376"
      end
    end
  end

  def install
    ENV.llvm_clang

    resource("bun-bootstrap").stage buildpath/"bootstrap"
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    # Trying to fix `-Wundefined-var-template` error
    # TODO: file an issue
    ENV.append "CXXFLAGS", "-Wno-undefined-var-template"

    system "bun", "run", "build:release"
    bin.install "build/release/bun"
    bin.install_symlink bin/"bun" => "bunx"

    bash_completion.install "completions/bun.bash" => "bun"
    zsh_completion.install "completions/bun.zsh" => "_bun"
    fish_completion.install "completions/bun.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")

    system bin/"bun", "init", "--yes"
    assert_path_exists "bun.lock"

    (testpath/"test.ts").write <<~TYPESCRIPT
      console.log("Hello world!");
    TYPESCRIPT

    assert_equal "Hello world!", shell_output("#{bin}/bun run test.ts").chomp
    assert_match "Hello world!", shell_output("#{bin}/bunx cowsay 'Hello world!'")
  end
end
