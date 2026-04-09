class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.21.0.tar.gz"
  mirror "https://github.com/rjarry/aerc/archive/refs/tags/0.21.0.tar.gz"
  sha256 "3f1469bbaea982fc58352f2682932ecc2fb50c705994d96b2343e771747745a7"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "a8f207daf51b4be7b0645bf3e81cacc2687190713bb13a59ad246419c469affb"
    sha256 arm64_sequoia: "1bc0619b2b30691c09fab1382cd6a9510b66278e08b58fb8255e62d2929f08d7"
    sha256 arm64_sonoma:  "fbd0023ba20b2075790a2a558434aa4c3fe18098d17cb129122f7ade45a8c4d5"
    sha256 arm64_ventura: "a993460fcf4acfdcef595f4ce9e4ae678358c11f79c9dff6bc7f09d5edb73d94"
    sha256 sonoma:        "8b46596c840dd14a947428e4669704bdee42c36d6ddaa617d8d69453137e5664"
    sha256 ventura:       "c04471c53a6b7db1b349937a7b81ecf5ea794f41aad35e9d9bc0e69e309453d0"
    sha256 arm64_linux:   "6d9361c0ff2d2c7fb8bfb3d80ec789d012547fed90bab51941250c10a07c6024"
    sha256 x86_64_linux:  "5f8a0e69f2b07a3fbbc3615af3ed930151e4d601632f2c25a3e8928068106492"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "notmuch"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV["BUILD_OPTS"] = "-buildmode=pie -trimpath"
    end

    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/aerc -v")
    assert_match(/aerc #{version} \+notmuch\.*/, output)
  end
end
