class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "b2154a45b8ab89f48d71451f128f0888e1107745ede943e510885f9026241567"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e5f5f027539468166a5c079299d8f0ee0d6d50940a26e4390e42971daa917bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "527c78cca6aba398f505342405998dcd719afd279527f9ed5d5cd887f731e583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b885a44748dac6cc6fa48756c100d698bad56ce17249e488fd80b5702e4110f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ab95a15eace178556bcd32e6bacc4d68da103f9abefe7b8c492300cbfd5c42"
    sha256 cellar: :any,                 arm64_linux:   "a70aa8aaa85b4d093e5d375d297500b67aefbb6eff60c32c92ae77d17b0889e0"
    sha256 cellar: :any,                 x86_64_linux:  "56d89a809d692162fb2ac428f17511140599e83adb3d80cca9df46c9bb8caafe"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gurk --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"gurk", "--relink", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Please enter your display name", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
