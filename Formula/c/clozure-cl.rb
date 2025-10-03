class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/refs/tags/v1.13.tar.gz"
  sha256 "bca7f8d70d49059f8937b82bc64f47f7d01c07dd18760002ec41b41c444f838c"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "dbf1d6fa306b45dd024bcb4affa6ecdae29269e2de18b6d97c9ed0a7bba5eeea"
    sha256 cellar: :any_skip_relocation, ventura:      "77beee69a1b3748ed9f627c31b5ee91bd6914ee614e6b49fc027e1ab76f3ce86"
    sha256 cellar: :any_skip_relocation, monterey:     "df21345c80cded7b9d732d1158a904bd0fe8118bd91da58fe99d3614c02f1e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d0f7c8987f103a1002a96a696df47d99765c6604ab91630121a0e1209c6afbb"
  end

  # https://github.com/Clozure/ccl/issues/11
  depends_on arch: :x86_64

  on_macos do
    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make linux-only when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      url "https://github.com/Clozure/ccl/releases/download/v1.13/darwinx86.tar.gz"
      sha256 "0eceab57e519f82bd6db011c596eb2a28e2a510abcd76e217d49a10e90f4002f"
    end

    on_linux do
      url "https://github.com/Clozure/ccl/releases/download/v1.13/linuxx86.tar.gz"
      sha256 "dd7dcb1631305cc7e32aef67caaa89662e05999dd30e72fbfa554a96f9473e13"
    end
  end

  def install
    resource("bootstrap").stage do
      if OS.mac?
        buildpath.install "dx86cl64.image"
        buildpath.install "darwin-x86-headers64"
      else
        buildpath.install "lx86cl64"
        buildpath.install "lx86cl64.image"
        buildpath.install "x86-headers64"
      end
    end

    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    if OS.mac?
      system "make", "-C", "lisp-kernel/darwinx8664"
      system "./dx86cl64", "-n", "-l", "lib/x8664env.lisp",
                           "-e", "(ccl:xload-level-0)",
                           "-e", "(ccl:compile-ccl)",
                           "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "dx86cl64.image")\n(quit)\n')
      system "cat image | ./dx86cl64 -n --image-name x86-boot64.image"
    else
      system "./lx86cl64", "-n", "-l", "lib/x8664env.lisp",
                           "-e", "(ccl:rebuild-ccl :full t)",
                           "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "lx86cl64.image")\n(quit)\n')
      system "cat image | ./lx86cl64 -n --image-name x86-boot64"
    end

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install libexec/"scripts/ccl64"
    bin.env_script_all_files(libexec/"bin", CCL_DEFAULT_DIRECTORY: libexec)
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
