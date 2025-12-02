class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.43.1.tar.gz"
  sha256 "177df2825210dd3512ff89507ab7d07da49fb4a3c7a0e9ac82cf4dedefa73010"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9019e8369d1f4bd025713dc85a721ee9becd2772b7145de9215ee41533a8d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4516e8f5e6e34a84539de9768fca0822ed0da9a9cedefc2ac19b3163b812e17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64ba24e1d91dfb705b8807cfb51a3cece65283dcee9b2ba500aaaf21af61ae63"
    sha256 cellar: :any_skip_relocation, sonoma:        "09f4bfdbf63df6df9e9124921f6a0f3afa6a2f752f09a7b46498666f4332f152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be23fb2030f6248954273092183c8bed77b20bb517ff54020d94d89fa8e26734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a0c05d55db2d7ca8b63d9be7c22780e527df89ad6e87111ca3d442a6576ebc"
  end

  depends_on "rust" => :build

  def install
    # Currently uses nightly rust features. Allow our stable rust to compile
    # these unstable features to avoid needing a rustup-downloaded nightly.
    # See https://rustc-dev-guide.rust-lang.org/building/bootstrapping/what-bootstrapping-does.html#complications-of-bootstrapping
    # Remove when fixed: https://github.com/facebook/pyrefly/issues/374
    ENV["RUSTC_BOOTSTRAP"] = "1"
    # Set JEMALLOC configuration for ARM builds
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args(path: "pyrefly")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> int:
          return f"Hello, {name}!"
    PYTHON

    output = shell_output("#{bin}/pyrefly check #{testpath}/test.py 2>&1", 1)
    assert_match "`str` is not assignable to declared return type `int`", output
  end
end
