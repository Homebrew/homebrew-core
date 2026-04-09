class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.94.0.tar.gz"
  sha256 "80510c426a7f94aa1e9e1f5051170272be16ea0889d20ffd2012e3ad3c35501f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f0a3fbd939f280e2a1c8c1192740cfde3fad1e8cccd350214d5b5a4d30798a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6637a12e70d9ce0a4330e1227987b4626732d600ecfe9142357243a4233a31a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "910da87ceba0eceffbc25a6c6e030cbe12f7b47d812b6f5e78a06f374d8a09a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef59fb29d8a417ab641207864f812ded16507db141b3ee86cc35ebadd4e0b61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2009c169e52575dce4a73480fff1ebec76deecaf13c5d1f679284cc270924890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a0acb728f96a054cbf8747692b1d7bf4d4df036394a3eebca32ed425360019"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
