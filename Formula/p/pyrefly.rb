class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.50.1.tar.gz"
  sha256 "7a5976c83fc9e0020d5e7aeb52a477dbf1812ad343524cd41a3a3154403fbfca"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b220b333b7ffdfd115711298244a80c257f118ebdea8779925d078d5555f26ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4461d29f5351bd43e8ec816ceb684b59ce724facb752454599360633409ae747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d10e35f93f671f6f335e5422e3be7f66f0f8a981cd0c154921552a97ae3358c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a19e1be14ba1f8e81f09cff5c4bd6e70386c0837fc896d798bd0a53dfb999c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4dbb62042c94182a1068b3d510b3761077020d39a5c3e7439964c729ec0d404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8500de7cd8091a2af71cda1b5296fe739787d59f5511ab866a2ebbb6f1305f6a"
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
