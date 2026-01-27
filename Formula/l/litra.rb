class Litra < Formula
  desc "Control Logitech Litra lights from the command-line"
  homepage "https://github.com/timrogers/litra-rs"
  url "https://github.com/timrogers/litra-rs/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "65cdeee13f75b18711f3217e788fa0396644e8f582fc8830313f81cd294eb685"
  license "MIT"
  head "https://github.com/timrogers/litra-rs.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "hidapi"
  end

  def install
    # Update to use system hidapi for linux build, upstream pr, https://github.com/timrogers/litra-rs/pull/210
    if OS.linux?
      inreplace "Cargo.toml",
                /^(\s*hidapi\s*=\s*)"([^"]+)"\s*$/,
                '\1{ version = "\2", default-features = false, features = ["linux-shared-hidraw"] }'
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litra --version")
    assert_match "No Logitech Litra devices found", shell_output("#{bin}/litra devices")
  end
end
