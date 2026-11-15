class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/refs/tags/v1.14.tar.gz"
  sha256 "b99cc0615ea41d3538aee068c998413aef12c3562684167905cc832bb77ef361"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b5b1be3282c54d8514b89cc45c91f6268bbac2cd5aa80a4777433f9653bced3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25022257c0255ef2f2e180a2a8795965a9f8862aa53f4f8f1b44e6f616d54cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea12d8bcc5606182ab2561f78ceb262d534a051c4f60ab93415fd6b048e369b9"
    sha256 cellar: :any,                 arm64_linux:       "cce229f0106748228548070a08beb92d6bc76676315772066698c1dd120df353"
    sha256 cellar: :any,                 x86_64_linux:      "12f5ce9962be5ce7dc49039c2ec38f1e28c872d8a9780bc75f937c6ab85018a3"
  end

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-darwinarm64.tar.gz"
        sha256 "c26d879053c6691182da779ceeadb7fd4e2d63d04a4a603cfff5a2f124be0211"
      end
      on_intel do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-darwinx86.tar.gz"
        sha256 "f69a70ff50677877e989e36818f0baa19fa4cb186440a7984a9ccdcd07236276"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-linuxarm64.tar.gz"
        sha256 "766c4ef63708ea9152f4565eb59d89a79ab3ddaf852a69c0ef91633f89f61332"
      end
      on_intel do
        url "https://github.com/Clozure/ccl/releases/download/v1.14/ccl-1.14-linuxx86.tar.gz"
        sha256 "96fff67c53b56dc67acc06e92ff1774b73401564650669c95e7c63f1200a4f5d"
      end
    end
  end

  deny_network_access!

  def install
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x86" : Hardware::CPU.arch.to_s
    suffix = Hardware::CPU.bits.to_s if Hardware::CPU.intel?

    kernel_prefix = os[0] if !OS.linux? || !Hardware::CPU.arm?
    kernel = "#{kernel_prefix}#{arch}cl#{suffix}"
    kernel_build_dir = "#{os}#{arch}#{suffix}"
    interface_database_dir_prefix = os + "-" unless OS.linux?
    interface_database_dir = "#{interface_database_dir_prefix}#{arch}-headers#{suffix}"

    resource("bootstrap").stage do
      buildpath.install interface_database_dir, "#{kernel}.image"
    end

    system "make", "-C", "lisp-kernel/#{kernel_build_dir}", "clean"
    system "make", "-C", "lisp-kernel/#{kernel_build_dir}", "all"
    system "./#{kernel}", "--no-init", "--batch",
                          "--eval", "(ccl:rebuild-ccl :full t)",
                          "--eval", "(quit)"

    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    (bin/"ccl").write_env_script(libexec/kernel, CCL_DEFAULT_DIRECTORY: libexec)
    bin.install_symlink "ccl" => "ccl#{Hardware::CPU.bits}"
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
