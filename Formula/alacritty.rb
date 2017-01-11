class Alacritty < Formula
  desc "Cross-platform, GPU-accelerated terminal emulator"
  homepage "https://github.com/jwilm/alacritty"
  revision 1
  head "https://github.com/jwilm/alacritty.git", :using => :git

  option "with-rustc-version", "Use 'rustc' version from distribution"

  def install
    unless build.head?
      odie "Only HEAD build is supported at time"
    end

    cargo_home = Pathname.new(ENV.fetch("CARGO_HOME", ENV.fetch("CURL_HOME", ".")))/".cargo"
    unless cargo_home.exist?
      odie "Could not find 'cargo' installation dir neither in CARGO_HOME nor in HOME"
    end

    rustup_path = (cargo_home/"bin").to_s
    unless which("rustup", rustup_path)
      odie "Current installation method requires 'rustup' to be present in system"
    end

    ENV.prepend_path "PATH", rustup_path

    rustc_version = "nightly"
    if build.with? "rustc-version"
      rustc_version_path = buildpath/"rustc-version"
      unless rustc_version_path.exist? && rustc_version_path.readable?
        odie "Could nor read 'rustc' version from #{rustc_version_path.to_s.inspect}"
      end

      rustc_version = rustc_version_path.read.tr("\n", "")
    end

    system "rustup", "override", "set", rustc_version

    cargo_args = ["--release"]
    cargo_args << "--verbose" if ARGV.verbose?

    system "cargo", "build", *cargo_args
    bin.install "target/release/alacritty"
  end

  test do
    alacritty_binary = bin/"alacritty"

    alacritty_binary.executable?
  end
end
