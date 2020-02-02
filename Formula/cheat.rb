class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.4.1",
    :revision => "57225442be37e26e89d50a2973ca59baf6b9e2ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "fac9267a41859f0feeffa77048b2ff3508b4d1e77b5dc4d69996d4d7dbb929fb" => :catalina
    sha256 "74be8231bcb1728f4357c945c69d1ba3898fae721865bdf17432cb573d29cd64" => :mojave
    sha256 "42b6a9d8868a3097e3438fbc95ff5167287bf5c5ed481b0aa9fb97a1a48515e1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "Created config file", shell_output("#{bin}/cheat tar 2>&1")
  end
end
