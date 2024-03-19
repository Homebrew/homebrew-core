class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.10.tar.gz"
  sha256 "37038d998b19d3a798cf99ffdcc0decfd35929c3a46901b3de46f10c46bb831c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ce48534b7dd2f03e270b4a6e8194c3d9455a9eb4d61e02463f2c1669eba8f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af85f1486d3972a670d057c305c685d564f3cf89787c5619ecfbb3eb7234a30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb18ee424028480388d6b8d392ad2cd7b9075e8a8eb92210ddc6c93081e84646"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0ba00880b34dd53e6dd3c6401d56053acdb5e1d062221103eebd0c60d882e17"
    sha256 cellar: :any_skip_relocation, ventura:        "ffb379e670015ed88fb64cc6582b513869aca83e1e7600e8f56abc9ce2ada354"
    sha256 cellar: :any_skip_relocation, monterey:       "f2237fb7a6537d22e298158901de2dedbea1373e98beef6af7b25fa465c6830b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a65c577e1880c847e808998644d7b0ba6e448c8d225927ce4007ef8a12889d"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
