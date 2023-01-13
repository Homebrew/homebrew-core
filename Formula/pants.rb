class Pants < Formula
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org"
  url "https://github.com/pantsbuild/scie-pants/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "bebe326350ee7477bc1ac8c9c79222e987e3ee01500b4e16a526134529eb9866"
  license "Apache-2.0"
  head "https://github.com/pantsbuild/scie-pants.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build

  def install
    # Setup rust environment that has `rustup` in it.
    ENV["CARGO_HOME"] = buildpath/".cargo"
    ENV["RUSTUP_HOME"] = buildpath/".rustup"
    system "rustup-init", "-y", "--profile", "minimal"

    # Run scie-pants package tool.
    ENV["PATH"] = "#{buildpath/".cargo/bin"}:#{ENV["PATH"]}"
    system "cargo", "run", "-p", "package", "--", "--dest-dir", ".", "scie"

    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    arch = Hardware::CPU.arch.to_s.sub("arm64", "aarch64")

    # Install binary.
    bin.install "scie-pants-#{os}-#{arch}" => "pants"
  end

  test do
    (testpath/"pants.toml").write <<~EOS
      [GLOBAL]
      pants_version = "2.14.0"
    EOS
    assert_match(/2.14.0$/, shell_output("pants version").strip)
  end
end
